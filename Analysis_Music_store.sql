/* Q1: Who is the senior most employee based on job title? */

Select * from employee
Order by levels DESC
Limit 1;


/* Q2: Which countries have the most Invoices? */

Select billing_country, Count(invoice_id) from invoice
Group by billing_country
Order by Count(invoice_id) DESC
Limit 1;


/* Q3: What are top 3 values of total invoice? */

Select total from invoice
Order by total DESC
Limit 3;


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

Select billing_city as city_name ,Sum(total) as invoice_totals from invoice
Group by billing_city
Order BY invoice_totals DESC
Limit 1; 


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

Select CONCAT(c.first_name, c.last_name) as Best_customer, sum(i.total) as Total_money_spent from customer c
join invoice i On c.customer_id=i.customer_id
Group by best_customer
order by Total_money_spent DESC
Limit 1;


/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

Select  Distinct(c.email) as Email, Concat(c.first_name, c.last_name) as Full_Name, g.name as Genre_name from customer c
Join invoice i on c.customer_id=i.customer_id 
Join invoice_line il on i.invoice_id=il.invoice_id
Join track t on il.track_id=t.track_id
Join genre g on t.genre_id=g.genre_id
where g.name='Rock'
Order by c.email;


/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

Select a.name as Name, count(a.artist_id) as rock_music_count from artist a
Join album alb on alb.artist_id=a.artist_id
Join track t on t.album_id=alb.album_id
Join genre g on g.genre_id=t.genre_id
where g.name='Rock'
Group by a.name
Order by rock_music_count DESC
Limit 10



/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

Select name,milliseconds from track
where milliseconds<(
	Select avg(milliseconds) from track
)
Order By milliseconds DESC


/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

WITH customer_spent_on_artist AS 
(
Select c.first_name, c.last_name, a.name as artist_name,sum(il.quantity*il.unit_price) as total_spent,
	ROW_NUMBER() OVER(PARTITION BY a.name ORDER BY sum(il.quantity*il.unit_price) DESC ) as RowNo
	from customer c
	Join invoice i on c.customer_id=i.customer_id
	Join invoice_line il on i.invoice_id=il.invoice_id
	Join track t on il.track_id= t.track_id
	Join album alb on t.album_id=alb.album_id
	Join artist a on alb.artist_id=a.artist_id
	Group By 1,2,3
	Order BY 1,2,3
)
Select first_name, last_name, artist_name,total_spent from customer_spent_on_artist
where RowNo<=1;



/* Q10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

WITH country_genre AS 
(
Select c.country,g.name as popular_genre,Count(il.quantity) as highest_purchase,
	ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY Count(il.quantity) DESC ) as RowNo
	from customer c
	Join invoice i on c.customer_id=i.customer_id
	Join invoice_line il on i.invoice_id=il.invoice_id
	Join track t on il.track_id= t.track_id
	Join genre g on t.genre_id=g.genre_id
	Group By 1,2
	Order BY 1,2
)
Select Country, popular_genre, highest_purchase from country_genre
where RowNo<=1;


/* Q11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

WITH country_customer AS 
(
Select c.country,c.first_name, c.last_name,sum(il.quantity*il.unit_price) as total_spent,
	ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY sum(il.quantity*il.unit_price) DESC ) as RowNo
	from customer c
	Join invoice i on c.customer_id=i.customer_id
	Join invoice_line il on i.invoice_id=il.invoice_id
	Join track t on il.track_id= t.track_id
	Join genre g on t.genre_id=g.genre_id
	Group By 1,2,3
	Order BY 1,2,3
)
Select Country, first_name, last_name, total_spent from country_customer
where RowNo<=1;


