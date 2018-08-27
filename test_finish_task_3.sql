begin 
    dbms_output.put_line('Studend ID: 101953626');
    dbms_output.put_line('================== PART 3 TEST LOCATION ==================');
    ADD_LOCATION_VIASQLDEV('AF201', 1, 2);
    ADD_LOCATION_VIASQLDEV('AF202', -3, 4);
    ADD_LOCATION_VIASQLDEV('AF203', 5, 1);
    ADD_LOCATION_VIASQLDEV('AF204', 6, 7000);
    ADD_LOCATION_VIASQLDEV('AF20111', 8, 9);
    ADD_LOCATION_VIASQLDEV('AF', 8, 9);
end;