#!/bin/bash

module unload MySQL
module unload xt-shmem
module swap PrgEnv-pgi PrgEnv-gnu
module load python/2.7.1
module load cmake/2.8.10.1

