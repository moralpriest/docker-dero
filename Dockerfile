FROM golang as builder

#Download source code
RUN git clone https://github.com/civilware/derodpkg.git

# Set working dir
WORKDIR /go/derodpkg

# Download Go modules
RUN go mod download
# Update modules dependacies
RUN go mod tidy

# Set vars
#ARG OS="linux"
#ARG ARCH="amd64"
LABEL org.opencontainers.image.authors="moralpriest@proton.me"

# Copy source code
#COPY . .

# Build the dero daemon binary 
#RUN CGO_ENABLED=0 go get -a -ldflags '-s' https://github.com/civilware/derodpkg.git
#RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -trimpath -ldflags="-w -s "-extldflags '-static'" -buildid=" -gcflags=all=" -l -B" -o derod .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -trimpath -ldflags="-w -s -buildid=" -gcflags=all=" -l -B" -o derod .

#RUN go build -o derod .
#RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o derod .

#test debug
#RUN GOOS=linux GOARCH=amd64 go build -ldflags "-s -w -extldflags '-static'" -o /derod .

#RUN addgroup -S rustscan && \
#    adduser -S -G rustscan rustscan && \
#    ulimit -n 100000 && \
#    apk add --no-cache nmap nmap-scripts wget
# USER rustscan

#Use a minimal base image
FROM scratch

#Use a minimal base image
#FROM alpine

# Update Alpine Linux Package Manager and Install the bash
#RUN apk update && apk add bash

#Copy the binary from the builder stage
COPY --from=builder /go/derodpkg/derod .

#Default mainnet ports GETWORK, DAEMON RPC, P2P, RPC, WALLET RPC
EXPOSE 20100 20101 20102 20103 
#Default testnet ports GETWORK ,P2P, RPC, WALLET RPC
#EXPOSE 40100 40101 40102 40103

#HEALTHCHECK - require curl
#HEALTHCHECK --interval=30s --timeout=5s CMD curl -f -X POST http://localhost:10102/json_rpc -H 'content-type: application/json' -d '{"jsonrpc": "2.0","id": "1","method": "DERO.Ping"}' || exit 1

#Start derod 
#ENTRYPOINT ["/go/derodpkg/derod", "--rpc-bind=0.0.0.0:10102", "--p2p-bind=0.0.0.0:10101", "--data-dir=/mnt/derod", "--integrator-address=dero1qyshrhaf0cev402lqw2g2slqf2v3r2rjq2xh03xgd852cjhrgdyqcqq0letdh"]

# DEBUGING STEP
#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["./derod"]
CMD ["--rpc-bind=0.0.0.0:10102", "--p2p-bind=0.0.0.0:10101", "--data-dir=/mnt/derod", "--integrator-address=dero1qyshrhaf0cev402lqw2g2slqf2v3r2rjq2xh03xgd852cjhrgdyqcqq0letdh"]
#ENTRYPOINT ["./derod", "--rpc-bind=0.0.0.0:10102", "--p2p-bind=0.0.0.0:10101", "--data-dir=/mnt/derod", "--integrator-address=dero1qyshrhaf0cev402lqw2g2slqf2v3r2rjq2xh03xgd852cjhrgdyqcqq0letdh"]
