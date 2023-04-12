/*
a. Escriba una consulta SQL que retorne los nombres de todos los productos
que no han sido pedidos por ningún cliente. Incluya el nombre del
producto, el nombre de la categoría y el nombre del proveedor en el
resultado.
i. Tablas: Products, Categories, Suppliers, Order Details
*/
SELECT 
P.[ProductName],
C.CategoryName,
S.CompanyName
--OD.ProductID
FROM [dbo].[Products] P
	INNER JOIN [dbo].[Categories] C ON C.CategoryID = P.CategoryID
		INNER JOIN [dbo].[Suppliers] S ON S.SupplierID = P.SupplierID
			LEFT JOIN [dbo].[Order Details] OD ON OD.ProductID = P.ProductID
WHERE OD.ProductID IS NULL

/*
b. Escriba una consulta SQL que retorne los nombres de todos los empleados
que tengan más de un colaborador a su cargo. Incluya el nombre del
colaborador, su puesto y el número de colaboradores a su cargo en el
resultado.
i. Tablas: Employees. 
*/

SELECT
	EM.EmployeeID AS "id",
	CONCAT(EM.FirstName,' ', EM.LastName) AS "Nombre del empleado",
	EM.Title AS "Puesto",
	COUNT(DISTINCT COLAB.EmployeeID) AS "Colaboradores"
FROM [dbo].[Employees] EM
	JOIN [dbo].[Employees] COLAB ON COLAB.ReportsTo = EM.EmployeeID
GROUP BY 
	EM.EmployeeID,
	CONCAT(EM.FirstName,' ', EM.LastName),
	EM.Title
HAVING COUNT(DISTINCT COLAB.EmployeeID) > 1

/*
c. Escriba una consulta que retorne los nombres y ID de todos los clientes
que hayan realizado más de 10 órdenes de compra.
i. Tablas: Customers. 
*/
SELECT 
	C.[CustomerID],
	C.[ContactName] AS "Nombre"
FROM [dbo].[Customers] C
	JOIN [dbo].[Orders] O ON C.[CustomerID] = O.[CustomerID]
GROUP BY 
	C.[CustomerID],
	C.[ContactName]
HAVING COUNT(DISTINCT O.[OrderID])>10


/*
d. Escriba una consulta que retorne el top 5 de clientes con la mayor cantidad
de ordenes solicitadas.
i. Tablas: Customers. 
*/
SELECT TOP 5
	C.[ContactName] AS "Nombre",
	COUNT(DISTINCT O.[OrderID]) AS "Ordenes"
FROM [dbo].[Customers] C
	JOIN [dbo].[Orders] O ON C.[CustomerID] = O.[CustomerID]
GROUP BY
	C.[ContactName]
ORDER BY
	COUNT(DISTINCT O.[OrderID]) DESC

/*
e. Escriba una consulta que retorne el nombre y ID de todos los productos
que se han pedido, pero no se han enviado para entrega.
i. Tablas: Products
*/
SELECT
	P.ProductName,
	P.ProductID
FROM [dbo].[Products] P
	INNER JOIN [dbo].[Order Details] OD ON OD.[ProductID] = P.[ProductID]
		INNER JOIN [dbo].[Orders] O ON O.[OrderID] = OD.[OrderID]
WHERE O.ShippedDate IS NULL


/*
f. Escriba una consulta que retorne los nombres y ID de los empleados que
han vendido productos a clientes de Francia y Alemania.
i. Tablas: Employees.
*/
SELECT
	CONCAT(E.FirstName,' ', E.LastName) AS "Nombre del empleado",
	E.EmployeeID
FROM [dbo].[Employees] E
	JOIN [dbo].[Orders] O ON O.[EmployeeID] = E.[EmployeeID]
		JOIN [dbo].[Customers] C ON C.[CustomerID] = O.[CustomerID]
WHERE C.[Country] like 'France' OR C.[Country] like 'Germany'
GROUP BY	
	CONCAT(E.FirstName,' ', E.LastName),
	E.EmployeeID

/*
g. Escriba una consulta del total de ventas por cada país registrado en el
sistema. 
*/
SELECT
	O.[ShipCountry] AS "Pais",
	COUNT(DISTINCT O.[OrderID]) AS "Total ventas"
FROM [dbo].[Orders] O
GROUP BY O.[ShipCountry]