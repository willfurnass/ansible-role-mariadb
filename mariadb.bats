#! /usr/bin/env bats
#
# Functional tests for a MariaDB server set up wit Ansible role bertvv.mariadb
#
# The variable SUT_IP, the IP address of the System Under Test must be set
# outside of the script.

@test 'Root user should not be able to run a query remotely' {
  run mysql --host="${SUT_IP}" \
    --user=root \
    --password='BuIxB0ukAm' \
    --execute="SHOW TABLES;" \
    mysql

  [ "${status}" -ne "0" ]
}

@test 'User ‘appusr’ should be able to run remote queries: SHOW TABLES' {
  mysql --host="${SUT_IP}" \
    --user=appusr \
    --password='tesiKy3lj@' \
    --execute="SHOW TABLES;" \
    myappdb
}

@test 'User ‘appusr’ should be able to run remote queries: SELECT' {
  mysql --host="${SUT_IP}" \
    --user=appusr \
    --password='tesiKy3lj@' \
    --execute="SELECT * FROM TestTable;" \
    myappdb
}

@test 'User ‘appusr’ should be able to run remote queries: UPDATE' {
  mysql --host="${SUT_IP}" \
    --user=appusr \
    --password='tesiKy3lj@' \
    --execute="UPDATE TestTable SET SurName='Smith' WHERE Id=1;" \
    myappdb
}

@test 'User ‘appusr’ should be able to run remote queries: INSERT' {
  mysql --host="${SUT_IP}" \
    --user=appusr \
    --password='tesiKy3lj@' \
    --execute="INSERT INTO TestTable (Id, GivenName, SurName) VALUES (100, 'Jimmy', 'Smith');" \
    myappdb
}

@test 'User ‘appusr’ should be able to run remote queries: DELETE' {
  mysql --host="${SUT_IP}" \
    --user=appusr \
    --password='tesiKy3lj@' \
    --execute="DELETE FROM TestTable WHERE Id=100;" \
    myappdb
}

@test 'User ‘appusr’ should not have access to ‘myotherdb’' {
  run mysql --host="${SUT_IP}" \
    --user=otheruser \
    --password='ir3.quTeg8' \
    --execute="SHOW TABLES;" \
    otherdb
  [ "${status}" -ne 0 ]
  echo "${output}"
  grep 'Access denied for user' <<< "${output}"
}

@test 'User ‘otheruser’ should not have access to ‘myotherdb’' {
  run mysql --host="${SUT_IP}" \
    --user=otheruser \
    --password='ir3.quTeg8' \
    --execute="SHOW TABLES;" \
    otherdb
  [ "${status}" -ne 0 ]
  echo "${output}"
  grep 'Access denied for user' <<< "${output}"
}


