# ZMLODATA

## Overview

Demo project from Lukyanau Mikhail to let you understand hwo you can create OData service from scratch upon of your data model without using additional frameworks as CDS+RAP or CDS+BOPF.

Also this project has a good documentation in SAP community where author is explaided full path of creating OData service from scratch by using Eclipse + ADT + adjusted SAP GUI accessible from Eclipse by Alt+F8.

## How to use

clone this project to your SAP instance by using `abapGIT` to previously created package `ZMLODATA`

![image](https://github.com/lukcad/ZMLODATA/assets/22641302/811ebb52-4c7d-4137-9a28-9eced665c4e8)

After activating your package should look like this one:

![image](https://github.com/lukcad/ZMLODATA/assets/22641302/6e7d9166-a85f-4837-9373-3bc017b9aa95)

Double press on GW Service Builder Project `ZML_TRAVELLING_ODT` to open project by SEGW transaction:

![image](https://github.com/lukcad/ZMLODATA/assets/22641302/e1395bc9-e04c-48fa-9349-411c55a5205a)

Use button `SAP Gateway Client` to open HTTP client and di requests to this service,
adjust request Header to adding these parameters:

| Header parameter | value|when to use:
|---|---|---|
|accept|applicaiton/json| GET, POST |
|content-type|applicaiton/json| GET, POST |
|if-match| * | PUT,PATCH,DELETE |

Example of executing GET

![image](https://github.com/lukcad/ZMLODATA/assets/22641302/80b2b690-540e-4671-b380-33874418e9ea)

Example of POST with structure of data for `deep insert`:

![Screenshot 2024-04-27 200628](https://github.com/lukcad/ZMLODATA/assets/22641302/68cee7d1-f2b2-47f8-aeef-5ba3595dadbf)

Happy studding code and programming!

Thank you!

Yours sincirely,

Mikhail. 





