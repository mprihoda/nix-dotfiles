#!/bin/sh

iptables -t nat -D POSTROUTING -o $1 -s 10.8.0.0/24 -j MASQUERADE
iptables -t nat -D POSTROUTING -o $1 -s 10.0.11.0/24 -j MASQUERADE
