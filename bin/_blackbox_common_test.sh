#!/usr/bin/env bash

#
# _blackbox_common_test.sh -- Unit tests of functions from _blackbox_common.sh
#

set -e
. "${0%/*}/_blackbox_common.sh"
. /Users/tlimoncelli/gitwork/blackbox/tools/test_functions.sh

PHASE 'Test cp-permissions: TestA'
touch TestA TestB TestC TestD
chmod 0347 TestA
chmod 0700 TestB
chmod 0070 TestC
chmod 0070 TestD
cp_permissions TestA TestB TestC
# NOTE: cp_permissions is not touching TestD.
assert_file_perm '--wxr--rwx' TestA
assert_file_perm '--wxr--rwx' TestB
assert_file_perm '--wxr--rwx' TestC
assert_file_perm '----rwx---' TestD  # TestD doesn't change.
rm -f TestA TestB TestC TestD

PHASE 'Test vcs_relative_path: TestA'
export REPOBASE='/Users/tlimoncelli/Applications (Parallels)/{fd3049c8-9fdd-48d5-aa16-d31daf3a6879} Applications.localized'
FILE='Microsoft  Windows Fax and Scan.app/Contents'
result=$(vcs_relative_path Contents)
echo result=XXX${result}XXX
if [[ $FILE != $result ]] ; then
  echo FAIL
fi

unencrypted_file=$(get_unencrypted_filename "${result}.gpg")
echo un=XXX${unencrypted_file}XXX
encrypted_file=$(get_encrypted_filename "${result}")
echo en=XXX${encrypted_file}XXX

echo '========== DONE.'
