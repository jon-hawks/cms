#!/bin/sh
################################################################################
# Print my external IP address.                                                #
################################################################################
dig +short myip.opendns.com @resolver1.opendns.com
