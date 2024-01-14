FROM ubuntu:latest

# Update, upgrade, and install dependencies
RUN apt -y update && apt -y upgrade
RUN apt -y install gcc g++ gfortran make git patch wget pkg-config liblapack-dev libmetis-dev

# Define work directory
WORKDIR /Trajectory-Optimization

# Copy contents from repository into work directory
COPY . .

# Clone Ipopt repository
RUN git clone --recursive https://github.com/coin-or/Ipopt.git && \
    git clone --recursive https://github.com/coin-or-tools/ThirdParty-Mumps.git

# Build the MUMPS Linear Solver
RUN cd ThirdParty-Mumps && \
    ./get.Mumps && \
    ./configure && \
    make && \
    make install

# Build Ipopt
RUN cd Ipopt && \
    mkdir build && \
    ./configure && \
    make && \
    make test && \
    make install
