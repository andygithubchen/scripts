#!/usr/bin/expect --
set timeout 30
spawn ssh root@120.24.160.149
expect "Password:"
send "Wind1748\r"

