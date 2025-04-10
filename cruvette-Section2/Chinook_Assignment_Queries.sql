
-- 1. Top 5 customers by total purchase amount
SELECT 
    c.CustomerId, 
    c.FirstName || ' ' || c.LastName AS CustomerName, 
    SUM(i.Total) AS TotalPurchase
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY TotalPurchase DESC
LIMIT 5;

-- 2. Most popular genre in terms of total tracks sold
SELECT 
    g.Name AS Genre, 
    COUNT(il.TrackId) AS TracksSold
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.GenreId
ORDER BY TracksSold DESC
LIMIT 1;

-- 3. Employees who are managers along with their subordinates
SELECT 
    m.EmployeeId AS ManagerId,
    m.FirstName || ' ' || m.LastName AS ManagerName,
    e.EmployeeId AS SubordinateId,
    e.FirstName || ' ' || e.LastName AS SubordinateName
FROM Employee e
JOIN Employee m ON e.ReportsTo = m.EmployeeId;

-- 4. Most sold album per artist
SELECT 
    ar.Name AS Artist,
    al.Title AS Album,
    COUNT(il.InvoiceLineId) AS TotalSold
FROM Artist ar
JOIN Album al ON ar.ArtistId = al.ArtistId
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY ar.ArtistId, al.AlbumId
HAVING 
    COUNT(il.InvoiceLineId) = (
        SELECT 
            MAX(Sales)
        FROM (
            SELECT 
                COUNT(il2.InvoiceLineId) AS Sales
            FROM 
                Album al2
                JOIN Track t2 ON al2.AlbumId = t2.AlbumId
                JOIN InvoiceLine il2 ON t2.TrackId = il2.TrackId
            WHERE 
                al2.ArtistId = ar.ArtistId
            GROUP BY al2.AlbumId
        )
    );

-- 5. Monthly sales trends in the year 2013
SELECT 
    STRFTIME('%Y-%m', InvoiceDate) AS Month,
    SUM(Total) AS MonthlySales
FROM Invoice
WHERE STRFTIME('%Y', InvoiceDate) = '2013'
GROUP BY Month
ORDER BY  Month;
