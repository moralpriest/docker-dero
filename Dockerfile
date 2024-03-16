FROM golang as build

#Set destination for COPY
WORKDIR /cmd

# Download Go modules
COPY go.mod go.sum ./
RUN go mod download

# Set vars
#ARG OS="linux"
#ARG ARCH="amd64"
LABEL org.opencontainers.image.authors="moralpriest@proton.me"

# Copy source code
COPY . .

# Build
RUN GOOS=linux GOARCH=amd64 go build -a -trimpath -ldflags="-w -s -buildid=" -gcflags=all="-l -B" -o derod ./cmd/main

FROM scratch
COPY --from=builder /cmd/derodpkg .

# Expose volume containing all `derod` data
#VOLUME $DIR/.dero/

# REST interface
#EXPOSE 8080

# P2P network (mainnet, testnet & regnet respectively)
#EXPOSE 8333 18333 18444

# RPC interface (mainnet, testnet & regnet respectively)
#EXPOSE 8332 18332 18443

# ZMQ ports (for transactions & blocks respectively)
# EXPOSE 28332 28333

#Startapp
CMD ["./derodpkg"]
