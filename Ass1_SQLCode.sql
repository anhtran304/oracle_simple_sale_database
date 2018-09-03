-- Part 1.1
set serveroutput on;
Create or Replace Procedure ADD_CUST_TO_DB(pcustid Number, pcustname Varchar2) as 
    epcustid_outrange Exception;
begin
    if (pcustid < 1) or (pcustid > 499) then
        raise epcustid_outrange;
    else
        insert into CUSTOMER(CUSTID, CUSTNAME, SALES_YTD, STATUS)
            values (pcustid, pcustname, 0, 'OK');
    end if;
exception
    when DUP_VAL_ON_INDEX then
        raise_application_error(-20010, 'Error: Duplicate customer ID');
    when epcustid_outrange then
        raise_application_error(-20002, 'Error: Customer ID out of range');
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure ADD_CUSTOMER_VIASQLDEV(pcustid Number, pcustname Varchar2) as 
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Adding Customer ' || pcustid || ' ' || pcustname);
    ADD_CUST_TO_DB(pcustid, pcustname);
    dbms_output.put_line('Customer Added OK');
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

-- Part 1.2
set serveroutput on;
Create or Replace Function DELETE_ALL_CUSTOMERS_FROM_DB return Number as 
    vCount Number;
begin
    delete from customer
        where exists (select * from customer);
    vCount := SQL%ROWCOUNT;
    return vCount;
exception
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure DELETE_ALL_CUSTOMERS_VIASQLDEV as 
    vCount Number;
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Deleting all Customer rows');
    vCount := DELETE_ALL_CUSTOMERS_FROM_DB();
    dbms_output.put_line(vCount || ' rows deleted');
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

-- Part 1.3 
set serveroutput on;
Create or Replace Procedure ADD_PROD_TO_DB(pprodid Number, pprodname Varchar2, pprice Number) as 
    epprodid_outrange Exception;
    epprice_outrange Exception;
begin
    if (pprodid < 1000) or (pprodid > 2500) then
        raise epprodid_outrange;
    else 
        if (pprice < 0) or (pprice > 999.99) then
            raise epprice_outrange;
        else
            insert into PRODUCT(PRODID, PRODNAME, SELLING_PRICE, SALES_YTD)
                values (pprodid, pprodname, pprice, 0);
        end if;
    end if;
exception
    when DUP_VAL_ON_INDEX then
        raise_application_error(-20010, 'Error: Duplicate Product ID');
    when epprodid_outrange then
        raise_application_error(-20012, 'Error: Product ID out of range');
    when epprice_outrange then
        raise_application_error(-20013, 'Error: Price out of range');
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure ADD_PRODUCT_VIASQLDEV(pprodid Number, pprodname Varchar2, pprice Number) as 
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Adding Product ' || pprodid || ' Name: ' || pprodname || ' Price: ' || pprice);
    ADD_PROD_TO_DB(pprodid, pprodname, pprice);
    dbms_output.put_line('Product Added OK');
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

Create or Replace Function DELETE_ALL_PRODUCTS_FROM_DB return Number as 
    vCount Number;
begin
    delete from PRODUCT
        where exists (select * from PRODUCT);
    vCount := SQL%ROWCOUNT;
    return vCount;
exception
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure DELETE_ALL_PRODUCTS_VIASQLDEV as 
    vCount Number;
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Deleting all Product rows');
    vCount := DELETE_ALL_PRODUCTS_FROM_DB();
    dbms_output.put_line(vCount || ' rows deleted');
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

-- Part 1.4
set serveroutput on;
Create or Replace Function GET_CUST_STRING_FROM_DB(pcustid Number) return Varchar2 as 
    vCus_string Varchar2(200);
    vCustomer customer%ROWTYPE;
begin
    select *
        into vCustomer
        from customer
        where custid = pcustid;
    vCus_string := 'Custid: ' || vCustomer.custid || ' Name: ' || vCustomer.custname || ' Status: ' || vCustomer.Status || ' SalesYTD: ' || vCustomer.Sales_YTD;
    return vCus_string;
 exception
    when NO_DATA_FOUND then
        raise_application_error(-20021, 'Customer ID not found');
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure GET_CUST_STRING_VIASQLDEV(pcustid Number) as 
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Getting Details for CustId ' || pcustid);
    dbms_output.put_line(GET_CUST_STRING_FROM_DB(pcustid));
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

Create or Replace Procedure UPD_CUST_SALESYTD_IN_DB(pcustid Number, pamt Number) as
    epamt_outrange Exception;
    eno_custid Exception;
begin
    if (pamt < -999.99 or pamt > 999.99) then
        raise epamt_outrange;     
    end if;
    update Customer
        set Sales_YTD = Sales_YTD + pamt
        where custid = pcustid;
    if (SQL%NOTFOUND) then
        raise eno_custid;      
    end if;
exception
  when eno_custid then
    raise_application_error(-20021, 'Error: Customer ID not found');
  when epamt_outrange then
    raise_application_error(-20032, 'Error: Amount out of range');
  when OTHERS then
    raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure UPD_CUST_SALESYTD_VIASQLDEV(pcustid Number, pamt Number) as 
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Updatting SalesYTD. Customer Id: ' || pcustid || ' Amount: ' || pamt);
    UPD_CUST_SALESYTD_IN_DB(pcustid, pamt);
    dbms_output.put_line('Update Ok');
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/


-- Part 1.5
set serveroutput on;
Create or Replace Function GET_PROD_STRING_FROM_DB(pprodid Number) return Varchar2 as 
    vProd_string Varchar2(200);
    vProduct product%ROWTYPE;
begin
    select *
        into vProduct
        from Product
        where prodid = pprodid;
    vProd_string := 'Prodid: ' || vProduct.prodid || ' Name: ' || vProduct.prodname || ' Price: ' || vProduct.selling_price || ' SalesYTD: ' || vProduct.Sales_YTD;
    return vProd_string;
 exception
    when NO_DATA_FOUND then
        raise_application_error(-20041, 'Product ID not found');
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure GET_PROD_STRING_VIASQLDEV(pprodid Number) as 
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Getting Details for Prod Id ' || pprodid);
    dbms_output.put_line(GET_PROD_STRING_FROM_DB(pprodid));
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

Create or Replace Procedure UPD_PROD_SALESYTD_IN_DB(pprodid Number, pamt Number) as 
    epamt_outrange Exception;
    eno_update Exception;
begin
    if (pamt < -999.99) or (pamt > 999.99) then
        raise epamt_outrange;
    end if;
    update product
        set Sales_YTD = Sales_YTD + pamt
        where prodid = pprodid;
    if (SQL%NOTFOUND) then
        raise eno_update;      
    end if;
exception
    when eno_update then
        raise_application_error(-20041, 'Error: Product ID not found');
    when epamt_outrange then
        raise_application_error(-20052, 'Error: Amount out of range');
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure UPD_PROD_SALESYTD_VIASQLDEV(pprodid Number, pamt Number) as 
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Updatting SalesYTD. Product Id: ' || pprodid || ' Amount: ' || pamt);
    UPD_PROD_SALESYTD_IN_DB(pprodid, pamt);
    dbms_output.put_line('Update Ok');
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

-- Part 1.6
set serveroutput on;
Create or Replace Procedure UPD_CUST_STATUS_IN_DB(pcustid Number, pstatus Varchar2) as 
    eno_update Exception;
    einvalid Exception;
begin
    if (UPPER(pstatus) = 'OK') or (UPPER(pstatus) = 'SUSPEND') then
        update customer
            set STATUS = UPPER(pstatus)
            where custid = pcustid;
    else
        raise einvalid;
    end if;
    if (sql%rowcount = 0) then
        raise eno_update;
    end if;
exception
    when eno_update then
        raise_application_error(-20061, 'Error: Customer ID not found');
    when einvalid then
        raise_application_error(-20062, 'Error: Invalid Status value');
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure UPD_CUST_STATUS_VIASQLDEV(pcustid Number, pstatus Varchar2) as 
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Updatting Status. Customer Id: ' || pcustid || ' New Status: ' || pstatus);
    UPD_CUST_STATUS_IN_DB(pcustid, pstatus);
    dbms_output.put_line('Update Ok');
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

-- Part 1.7
set serveroutput on;
Create or Replace Procedure ADD_SIMPLE_SALE_TO_DB(pcustid Number, pprodid Number, pqty Number) as 
    vCust_count Number := 0;
    vProd_count Number := 0;
    vCustomer customer%ROWTYPE;
    vProduct product%ROWTYPE;
    esale_outrange Exception; 
    einvalid Exception;
    eno_custid Exception;
    eno_prodid Exception;
begin
    if (pqty < 1) or (pqty > 999) then
      raise esale_outrange;
    else    
        select count(*)
            into vCust_count
            from customer
            where custid = pcustid;
    end if;
    if vCust_count = 0 then
        raise eno_custid;
    else
        select *
            into vCustomer
            from customer
            where custid = pcustid;
        select count(*)
            into vProd_count
            from product
            where prodid = pprodid;
    end if;
    if vProd_count = 0 then
        raise eno_prodid;
    else
        if vCustomer.Status = 'OK' then
            select *
                into vProduct
                from product
                where prodid = pprodid;
            UPD_CUST_SALESYTD_IN_DB(pcustid, (pqty * vProduct.Selling_price));
            UPD_PROD_SALESYTD_IN_DB(pprodid, (pqty * vProduct.Selling_price));
        else
            raise einvalid;
        end if;
    end if;    
exception
    when esale_outrange then
        raise_application_error(-20071, 'Error: Sale Quantity outside valid range');
    when einvalid then
        raise_application_error(-20072, 'Error: Customer status is not OK');
    when eno_custid then
        raise_application_error(-20073, 'Error: Customer ID not found');
    when eno_prodid then
        raise_application_error(-20076, 'Error: Product ID not found');
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure ADD_SIMPLE_SALE_VIASQLDEV(pcustid Number, pprodid Number, pqty Number) as 
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Adding Simple Sales. Cust Id: ' || pcustid || ' Prod Id: ' || pprodid || ' Qty: ' || pqty);
    ADD_SIMPLE_SALE_TO_DB(pcustid, pprodid, pqty);
    dbms_output.put_line('Added Simple Sale Ok');
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

-- Part 1.8
set serveroutput on;
Create or Replace Function SUM_CUST_SALESYTD return Number as 
    vSum Number;
begin
    select sum(Sales_YTD)
        into vSum
        from customer;
    return vSum;
exception
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure SUM_CUST_SALES_VIASQLDEV as 
    vSum Number;
begin
    begin 
        dbms_output.put_line('-----------------------------');
        dbms_output.put_line('Summing Customer SalesYTD');
        vSum := SUM_CUST_SALESYTD();
        if vSum is NULL then
            vSum := 0;
        end if;
    exception
        when NO_DATA_FOUND then 
            vSum := 0;
        when OTHERS then
            dbms_output.put_line(sqlerrm);
        end;
    dbms_output.put_line('All Customer Total: ' || vSum);
end;
/

Create or Replace Function SUM_PROD_SALESYTD_FROM_DB return Number as 
    vSum Number;
begin
    select sum(Sales_YTD)
        into vSum
        from product;
    return vSum;
exception
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure SUM_PROD_SALES_VIASQLDEV as 
    vSum Number;
begin
    begin 
        dbms_output.put_line('-----------------------------');
        dbms_output.put_line('Summing Product SalesYTD');
        vSum := SUM_PROD_SALESYTD_FROM_DB();
        if vSum is NULL then
            vSum := 0;
        end if;
    exception
        when NO_DATA_FOUND then 
            vSum := 0;
        when OTHERS then
            dbms_output.put_line(sqlerrm);
        end;
    dbms_output.put_line('All Product Total: ' || vSum);
end;
/

-- Part 2
set serveroutput on;
Create or Replace function GET_ALLCUST return SYS_REFCURSOR as   
    rv_sysrefcur SYS_REFCURSOR;
begin  
    open rv_sysrefcur 
        for select * from customer;  
    return rv_sysrefcur;
exception
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure GET_ALLCUST_VIASQLDEV as 
    rv_sysrefcur SYS_REFCURSOR;
    reccust customer%ROWTYPE;
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Listing All Customer Details');
    rv_sysrefcur := GET_ALLCUST();
    loop
        fetch rv_sysrefcur into reccust;
        exit when rv_sysrefcur%NOTFOUND;
        dbms_output.put_line('Custid: ' || reccust.Custid || ' Name: ' || reccust.Custname || ' Status: ' || reccust.Status || ' SalesYTD: ' || reccust.Sales_YTD);
    end loop;
    close rv_sysrefcur;
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

Create or Replace function GET_ALLPROD_FROM_DB return SYS_REFCURSOR as   
    rv_sysrefcur SYS_REFCURSOR;
begin  
    open rv_sysrefcur 
        for select * from product;  
    return rv_sysrefcur;
exception
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure GET_ALLPROD_VIASQLDEV as 
    rv_sysrefcur SYS_REFCURSOR;
    recprod Product%ROWTYPE;
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Listing All Product Details');
    rv_sysrefcur := GET_ALLPROD_FROM_DB();
    loop
        fetch rv_sysrefcur into recprod;
        exit when rv_sysrefcur%NOTFOUND;
        dbms_output.put_line('Prodid: ' || recprod.Prodid || ' Name: ' || recprod.Prodname || ' Price: ' || recprod.Selling_price || ' SalesYTD: ' || recprod.Sales_YTD);
    end loop;
    close rv_sysrefcur;
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

-- Part 3
set serveroutput on;
Create or Replace FUNCTION strip_constraint(pErrmsg VARCHAR2 ) RETURN VARCHAR2 AS 
    rp_loc NUMBER; 
    dot_loc NUMBER;
BEGIN   
    dot_loc := INSTR(pErrmsg , '.');  
    rp_loc  := INSTR(pErrmsg , ')');  
    IF (dot_loc = 0 OR rp_loc = 0 ) THEN       
        RETURN NULL ;   
    ELSE  
        RETURN UPPER(SUBSTR(pErrmsg,dot_loc+1,rp_loc-dot_loc-1));   
    END IF;
END;
/
Create or Replace Procedure ADD_LOCATION_TO_DB(ploccode Varchar2, pminqty Number, pmaxqty Number) as 
    dbms_constraint_name Varchar2(240);
    CHECK_LOCID_LENGTH Exception;
    PRAGMA EXCEPTION_INIT(CHECK_LOCID_LENGTH, -12899);
begin
    insert into Location(Locid, minqty, maxqty) 
        values (ploccode, pminqty, pmaxqty);
exception
    when DUP_VAL_ON_INDEX then
        raise_application_error(-20081, 'Error: Duplicate location ID');
    when CHECK_LOCID_LENGTH then 
        raise_application_error(-20082, 'Error: Location Code length invalid');
    when OTHERS then
        dbms_constraint_name := strip_constraint(SQLERRM);
        case dbms_constraint_name
            when 'CHECK_LOCID_LENGTH' then 
                raise_application_error(-20082, 'Error: Location Code length invalid');
            when 'CHECK_MINQTY_RANGE' then 
                raise_application_error(-20083, 'Error: Minimum Qty out of range');
            when 'CHECK_MAXQTY_RANGE' then 
                raise_application_error(-20084, 'Error: Maximum Qty out of range');
            when 'CHECK_MAXQTY_GREATER_MIXQTY' then 
                raise_application_error(-20086, 'Error: Minimum Qty larger than Maximum Qty');
        else 
            raise_application_error(-20000, sqlerrm);
        end case;
end;
/

Create or Replace Procedure ADD_LOCATION_VIASQLDEV(ploccode Varchar2, pminqty Number, pmaxqty Number) as 
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Adding Location LocCode: ' || ploccode || ' MinQty: ' || pminqty || ' MaxQty: ' || pmaxqty);
    ADD_LOCATION_TO_DB(ploccode, pminqty, pmaxqty);
    dbms_output.put_line('Location Added OK');
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

-- Part 4
set serveroutput on;
Create or Replace Procedure ADD_COMPLEX_SALE_TO_DB(pcustid Number, pprodid Number, pqty Number, pdate Varchar2) as 
    vCust_count Number := 0;
    vProd_count Number := 0;
    vCustomer customer%ROWTYPE;
    vPrice Number;
    esale_outrange Exception; 
    einvalid Exception;
    bad_date Exception;
    vDate DATE;
    PRAGMA Exception_init(bad_date, -01847);
    PRAGMA Exception_init(bad_date, -01843);
    PRAGMA Exception_init(bad_date, -01840);
begin
    if (Length(pdate) <> 8) then
        raise bad_date;
    end if;
    if (pqty < 1) or (pqty > 999) then
      raise esale_outrange;
    end if;
    select * 
        into vCustomer
        from customer
        where custid = pcustid;
    if (vCustomer.status != 'OK') then
        raise einvalid;      
    end if;
    vDate := TO_DATE(pdate,'YYYYMMDD');
    select selling_price
        into vPrice
        from product
        where prodid = pprodid;
    insert into Sale(saleid, custid, prodid, qty, price, saledate)
        values (SALE_SEQ.NextVal, vCustomer.custid, pprodid, pqty, vPrice, vDate);
    UPD_CUST_SALESYTD_IN_DB(pcustid, (pqty * vPrice));
    UPD_PROD_SALESYTD_IN_DB(pprodid, (pqty * vPrice));
exception
    when NO_DATA_FOUND then 
        if vCustomer.status IS NULL then
            raise_application_error(-20094, 'Error: Customer ID not found');
        end if;
        if vPrice IS NULL then
            raise_application_error(-20095, 'Error: Product ID not found');
        end if;
    when bad_date then
        raise_application_error(-20093, 'Error: Invalid Date');
    when esale_outrange then
        raise_application_error(-20091, 'Error: Sale Quantity outside valid range');
    when einvalid then
        raise_application_error(-20092, 'Error: Customer status is not OK');
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/
Create or Replace Procedure ADD_COMPLEX_SALE_VIASQLDEV(pcustid Number, pprodid Number, pqty Number, pdate Varchar2) as 
    vPrice Number;
    vProd_count Number:=0;
    eno_prodid Exception;
begin
    begin
        select Selling_price
            into vPrice
            from product
            where prodid = pprodid;
    exception
      when no_data_found then
        null;
    end;
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Adding Complex Sales. Cust Id: ' || pcustid || ' Prod Id: ' || pprodid || ' Date: ' || pdate || ' Amount: ' || (pqty * vPrice));
    ADD_COMPLEX_SALE_TO_DB(pcustid, pprodid, pqty, pdate);
    dbms_output.put_line('Added Complex Sale Ok');
exception
    when OTHERS then
        dbms_output.put_line(sqlerrm);
end;
/

Create or Replace function GET_ALLSALES_FROM_DB return SYS_REFCURSOR as   
    rv_sysrefcur SYS_REFCURSOR;
begin  
    open rv_sysrefcur 
        for select * from sale;  
    return rv_sysrefcur;
exception
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure GET_ALLSALES_VIASQLDEV as 
    rv_sysrefcur SYS_REFCURSOR;
    recsale sale%ROWTYPE;
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Listing All Complex Sales Details');
    rv_sysrefcur := GET_ALLSALES_FROM_DB();
    loop
        fetch rv_sysrefcur into recsale;
        exit when rv_sysrefcur%NOTFOUND;
        dbms_output.put_line('Saleid: ' || recsale.saleid || ' Custid: ' || recsale.custid || ' Prodid: ' || recsale.prodid || ' Date: ' || TO_CHAR(recsale.saledate, 'YYYYMMDD') || ' Amount: ' || (recsale.qty * recsale.price) );
    end loop;
    close rv_sysrefcur;
exception
    when OTHERS then
        dbms_output.put_line(sqlerrm);
end;
/

Create or Replace Function COUNT_PRODUCT_SALES_FROM_DB(pday Number) return Number as 
    vCount Number;
begin
    select count(saledate) 
        into vCount
        from sale
        where ((SYSDATE-saledate) < pday);
    return vCount;
exception
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure COUNT_PRODUCT_SALES_VIASQLDEV(pday Number) as 
    vSum Number;
begin
    begin 
        dbms_output.put_line('-----------------------------');
        dbms_output.put_line('Counting sales within ' || round(pday, 0) || ' days');
        vSum := COUNT_PRODUCT_SALES_FROM_DB(round(pday));
        if vSum is NULL then
            vSum := 0;
        end if;
    exception
        when NO_DATA_FOUND then 
            vSum := 0;
        when OTHERS then
            dbms_output.put_line(sqlerrm);
        end;
    dbms_output.put_line('Total number of sales ' || vSum);
end;
/

-- Part 5
set serveroutput on;
Create or Replace Function DELETE_SALE_FROM_DB return Number as 
    vMin sale.saleid%TYPE;
    vSale Sale%ROWTYPE;
    vProduct Product%ROWTYPE;
    vCustomer Customer%ROWTYPE;
    CHECK_SALE_ROWS_FOUND Exception;
    PRAGMA EXCEPTION_INIT(CHECK_SALE_ROWS_FOUND, -20101);
begin
    select MIN(saleid)
        into vMin
        from sale;
    if vMIn is NULL then
        raise CHECK_SALE_ROWS_FOUND;
    else
        select * 
            into vSale
            from Sale
            where saleid = vMin;
        delete 
            from sale
            where saleid = vMin;
        select * 
            into vCustomer
            from Customer
            where custid = vSale.custid; 
        select * 
            into vProduct
            from Product
            where prodid = vSale.prodid; 
    end if;
        UPD_CUST_SALESYTD_IN_DB(vSale.custid, -(vSale.qty * vSale.price));
        UPD_PROD_SALESYTD_IN_DB(vSale.prodid, -(vSale.qty * vSale.price)); 
    return vMin;
exception
    when CHECK_SALE_ROWS_FOUND then 
        raise_application_error(-20101, 'No Sale Rows Found'); 
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure DELETE_SALE_VIASQLDEV as 
    vSaleid Number;
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Deleting Sale with smallest SaleId value');
    vSaleid := DELETE_SALE_FROM_DB;
    dbms_output.put_line('Deleted Sale OK. SaleId: ' || vSaleid);
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

Create or Replace Procedure DELETE_ALL_SALES_FROM_DB as 
    rv_sysrefcur_cust SYS_REFCURSOR;
    rv_sysrefcur_prod SYS_REFCURSOR;
    reccust customer%ROWTYPE;
    recprod product%ROWTYPE;
begin
    delete from sale;
    open rv_sysrefcur_cust for select * from customer;
    loop
        fetch rv_sysrefcur_cust into reccust;
        exit when rv_sysrefcur_cust%NOTFOUND;
        UPD_CUST_SALESYTD_IN_DB(reccust.custid, (-reccust.Sales_YTD));
    end loop;
    close rv_sysrefcur_cust;
    open rv_sysrefcur_prod for select * from product;
    loop
        fetch rv_sysrefcur_prod into recprod;
        exit when rv_sysrefcur_prod%NOTFOUND;
        UPD_PROD_SALESYTD_IN_DB(recprod.prodid, (-recprod.Sales_YTD));
    end loop;
    close rv_sysrefcur_prod;
exception
    when OTHERS then
        raise_application_error(-20000, sqlerrm);
end;
/

Create or Replace Procedure DELETE_ALL_SALES_VIASQLDEV as 
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Deleting all Sale data in Sale, Customer, and Product tables');
    DELETE_ALL_SALES_FROM_DB;
    dbms_output.put_line('Deletion OK');
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/
-- Part 6
set serveroutput on;
Create or Replace Procedure DELETE_CUSTOMER(pcustid Number) as 
    eno_custid Exception;
    CHILD_RECORD_FOUND Exception;
    PRAGMA EXCEPTION_INIT(CHILD_RECORD_FOUND, -2292);
begin
    delete from customer
        where custid = pcustid;
    if SQL%NOTFOUND then 
        raise eno_custid;
    end if;
exception
    when eno_custid then
        raise_application_error(-20201, 'Error: Customer ID not found');
    when CHILD_RECORD_FOUND then
        raise_application_error(-20202, 'Error: Customer cannot be deleted as sales exist');
    when OTHERS then
        raise_application_error(-2000, sqlerrm);
end;
/

Create or Replace Procedure DELETE_CUSTOMER_VIASQLDEV(pcustid Number) as 
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Deleting Customer. Cust Id: ' || pcustid);
    DELETE_CUSTOMER(pcustid);
    dbms_output.put_line('Deleted Customer OK');
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/

Create or Replace Procedure DELETE_PROD_FROM_DB(pprodid Number) as 
    eno_prodid Exception;
    CHILD_RECORD_FOUND Exception;
    PRAGMA EXCEPTION_INIT(CHILD_RECORD_FOUND, -2292);
begin
    delete from Product
        where prodid = pprodid;
    if SQL%NOTFOUND then 
        raise eno_prodid;
    end if;
exception
    when eno_prodid then
        raise_application_error(-20301, 'Error: Product ID not found');
    when CHILD_RECORD_FOUND then
        raise_application_error(-20302, 'Error: Product cannot be deleted as sales exist');
    when OTHERS then
        raise_application_error(-2000, sqlerrm);
end;
/

Create or Replace Procedure DELETE_PROD_VIASQLDEV(pprodid Number) as 
begin
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Deleting Product. Prod Id: ' || pprodid);
    DELETE_PROD_FROM_DB(pprodid);
    dbms_output.put_line('Deleted Product OK');
exception
  when OTHERS then
    dbms_output.put_line(sqlerrm);
end;
/
