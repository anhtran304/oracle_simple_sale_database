select * from customer;
select * from product;
begin 
    
    ADD_CUSTOMER_VIASQLDEV(10, 'Mieko Hayashi');
    ADD_CUSTOMER_VIASQLDEV(11, 'John Kalia');
    ADD_CUSTOMER_VIASQLDEV(12, 'Alex Kim');
    ADD_PRODUCT_VIASQLDEV(2001, 'Chair', 10);
    ADD_PRODUCT_VIASQLDEV(2002, 'Table', 45);
    ADD_PRODUCT_VIASQLDEV(2003, 'Lamp', 22);
    ADD_COMPLEX_SALE_VIASQLDEV(10, 2001, 6, '20140301');
    ADD_COMPLEX_SALE_VIASQLDEV(10, 2002, 1, '20140320');
    ADD_COMPLEX_SALE_VIASQLDEV(11, 2001, 1, '20140301');
    ADD_COMPLEX_SALE_VIASQLDEV(11, 2003, 2, '20140215');
    ADD_COMPLEX_SALE_VIASQLDEV(12, 2001, 10, '20140131');
    COUNT_PRODUCT_SALES_VIASQLDEV(sysdate-to_date('01-Jan-2014'));
    COUNT_PRODUCT_SALES_VIASQLDEV(sysdate-to_date('01-Feb-2014'));
    GET_ALLSALES_VIASQLDEV;
    ADD_COMPLEX_SALE_VIASQLDEV(99, 2001, 10, '20140131');
    ADD_COMPLEX_SALE_VIASQLDEV(12, 9999, 10, '20140131');
    ADD_COMPLEX_SALE_VIASQLDEV(12, 2001, 9999, '20140131');
    ADD_COMPLEX_SALE_VIASQLDEV(12, 2001, 10, '99999999');
    ADD_COMPLEX_SALE_VIASQLDEV(12, 2001, 10, '201401331');
    ADD_COMPLEX_SALE_VIASQLDEV(12, 2001, 10, '20140132');
    ADD_COMPLEX_SALE_VIASQLDEV(12, 2001, 10, '20140');
    ADD_COMPLEX_SALE_VIASQLDEV(12, 2001, 10, '201401311');
    UPD_CUST_STATUS_VIASQLDEV(12, 'OK');
    ADD_COMPLEX_SALE_VIASQLDEV(12, 2002, 10, '20140131');
end;
/