# ZMLODATA

## Overview

Demo project from Lukyanau Mikhail to let you understand how you can create OData service from scratch upon of your data model without using additional frameworks as CDS+RAP or CDS+BOPF.

Also this project has a good documentation in SAP community where author is explaided full path of creating OData service from scratch by using Eclipse + ADT + adjusted SAP GUI accessible from Eclipse by Alt+F8.

## How to use

clone this project to your SAP instance by using `abapGIT` to previously created package `ZMLODATA`

![image](https://github.com/lukcad/ZMLODATA/assets/22641302/811ebb52-4c7d-4137-9a28-9eced665c4e8)

After activating your package should look like this one:

![image](https://github.com/lukcad/ZMLODATA/assets/22641302/6e7d9166-a85f-4837-9373-3bc017b9aa95)

Double press on GW Service Builder Project `ZML_TRAVELLING_ODT` to open project by SEGW transaction:

![image](https://github.com/lukcad/ZMLODATA/assets/22641302/e1395bc9-e04c-48fa-9349-411c55a5205a)

In project `ZML_TRAVELLING_ODT` open the node `Service maintenance` and choose accessible SAP Gateway and press button `+Register` to make registration of service:

![image](https://github.com/lukcad/ZMLODATA/assets/22641302/e95842e4-da50-4909-89b0-128e1676cafd)

Once service is registerd you can use button `SAP Gateway Client` to open HTTP client and do requests to this service.

To work with JSON format adjust request Header by adding these parameters:

| Header parameter | value|when to use:
|---|---|---|
|accept|applicaiton/json| GET, POST |
|content-type|applicaiton/json| GET, POST |
|if-match| * | PUT,PATCH,DELETE |

Example of executing method GET by URI: /sap/opu/odata/sap/ZML_TRAVELLING_ODT_SRV/ZML_ITRAVELSet?$expand=TO_BOOKING


![image](https://github.com/lukcad/ZMLODATA/assets/22641302/80b2b690-540e-4671-b380-33874418e9ea)

Example of executing method POST with structure for `deep insert`:

URI: /sap/opu/odata/sap/ZML_TRAVELLING_ODT_SRV/ZML_ITRAVELSet

![Screenshot 2024-04-27 200628](https://github.com/lukcad/ZMLODATA/assets/22641302/68cee7d1-f2b2-47f8-aeef-5ba3595dadbf)

Table of all possible for this service CRUD operations:

| Name operation | Method | Header parameters | Body of request | URI |
|---|---|---|---|---|
|Read Travels | GET | accept:applicaiton/json content-type:applicaiton/json | - | /sap/opu/odata/sap/ZML_TRAVELLING_ODT_SRV/ZML_ITRAVELSet |
|Read Travels with Bookings | GET | accept:applicaiton/json content-type:applicaiton/json | - | /sap/opu/odata/sap/ZML_TRAVELLING_ODT_SRV/ZML_ITRAVELSet?$expand=BOOKING_TO |
|Read Bookings | GET | accept:applicaiton/json content-type:applicaiton/json | - | /sap/opu/odata/sap/ZML_TRAVELLING_ODT_SRV/ZML_IBOOKINGSet |
|Create Travel and Bookings | POST | accept:applicaiton/json content-type:applicaiton/json | { "Name": "Test travel 1", TO_BOOKING: [ { "Hotel": "Test Hotel", "Dayfrom" : "\/Date(1481760000000)\/", "Dayto" : "\/Date(1481760000000)\/" } ] } | /sap/opu/odata/sap/ZML_TRAVELLING_ODT_SRV/ZML_ITRAVELSet |
|Create Booking ( you should know TravelId ) | POST | accept:applicaiton/json content-type:applicaiton/json | { "TravelId" : "0242ac11-0002-1eef-80aa-0315685dd657", "Hotel": "Test Hotel", "Dayfrom" : "\/Date(1481760000000)\/", "Dayto" : "\/Date(1481760000000)\/" } | /sap/opu/odata/sap/ZML_TRAVELLING_ODT_SRV/ZML_IBOOKINGSet |
|Replace Travel record (you should know TravelId) | PUT | accept:applicaiton/json content-type:applicaiton/json if-match:* | { "Client": "001", "Name": "Test travel 1"} | /sap/opu/odata/sap/ZML_TRAVELLING_ODT_SRV/ZML_ITRAVELSet(guid('"0242ac11-0002-1eef-80aa-0315685dd657"')) |
|Change Travel record  (you should know TravelId) | PATCH | accept:applicaiton/json content-type:applicaiton/json if-match:* | { "Client": "001", "Name": "Test travel 1"} | /sap/opu/odata/sap/ZML_TRAVELLING_ODT_SRV/ZML_ITRAVELSet(guid('"0242ac11-0002-1eef-80aa-0315685dd657"') |
|Replace Booking record (you should know BookingId) | PUT | accept:applicaiton/json content-type:applicaiton/json if-match:* | { "TravelId" : "0242ac11-0002-1eef-80aa-0315685dd657", "Hotel": "Test Hotel", "Dayfrom" : "\/Date(1481760000000)\/", "Dayto" : "\/Date(1481760000000)\/" }  | /sap/opu/odata/sap/ZML_TRAVELLING_ODT_SRV/ZML_IBOOKINGSet(guid('"0242ac11-0002-1eef-80aa-0315685dd657"')) |
|Change Booking record  (you should know BookingId) | PATCH | accept:applicaiton/json content-type:applicaiton/json if-match:* | { "Hotel": "Test Hotel" }  | /sap/opu/odata/sap/ZML_TRAVELLING_ODT_SRV/ZML_IBOOKINGSet(guid('"0242ac11-0002-1eef-80aa-0315685dd657"') |
|Delete Travel record  (you should know TravelId) | DELETE | accept:applicaiton/json content-type:applicaiton/json if-match:* | - | /sap/opu/odata/sap/ZML_TRAVELLING_ODT_SRV/ZML_ITRAVELSet(guid('"0242ac11-0002-1eef-80aa-0315685dd657"') |
|Delete Booking record  (you should know BookingId) | DELETE | accept:applicaiton/json content-type:applicaiton/json if-match:* | - | /sap/opu/odata/sap/ZML_TRAVELLING_ODT_SRV/ZML_IBOOKINGSet(guid('"0242ac11-0002-1eef-80aa-0315685dd657"') |

## Understanding code

Please read documentation about this on my blog in SAP community here: [SAP community blog: Creation of Odata Service with implementation of CRUD methods and deep inserting](https://community.sap.com/t5/application-development-blog-posts/creation-of-odata-service-with-implementation-of-crud-methods-and-deep/ba-p/13685666)

Happy studding code and programming!

Thank you!

Yours sincirely,

Mikhail. 





