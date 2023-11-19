
-- TUGAS - PERTEMUAN 10

-- Database yang digunakan adalah Sakila Database.
use sakila;

-- SOAL

-- 1) Tampilkan 10 aktor yang paling banyak memerankan film dengan durasi lebih dari 60 menit, dan memiliki 'Behind The Scenes' special feature.
-- 	  Tampilkan juga actor id, genre film, dan jumlah film yang sudah ia perankan.
-- JAWAB:
select	a.actor_id as 'actor id',
		concat(a.first_name,' ', a.last_name) as fullname,
		cat.name as 'genre film',
		count(distinct fa.film_id) as 'jumlah film'
from	actor a 
join	film_actor fa on fa.actor_id = a.actor_id 
join 	film f on f.film_id = fa.film_id 
join 	film_category fc on fc.film_id = f.film_id 
join 	category cat on cat.category_id = fc.category_id 
where	f.`length` > 60 
		and f.special_features like ('Behind%')
group by 1, 3
order by 4 desc
limit 10;


-- 2) Tampilkan 5 film yang paling laris dipinjam pada database ini, jika dilihat dari jumlah total salesnya. 
-- 	  Tampilkan juga jumlah total salesnya, jumlah order nya, dan berapa customer yang sudah order film tersebut.
-- JAWAB:
select	f.title as 'judul',
		count(r.customer_id) as 'jumlah order',
		count(p.customer_id) as 'jumlah order customer', 
		sum(p.amount) as 'jumlah sales'		
from 	payment p 
join	rental r on  r.rental_id = p.rental_id 
join 	inventory i on i.inventory_id = r.inventory_id 
join 	film f on f.film_id = i.film_id 
group by 1
order by sum(p.amount) desc
limit 5;


-- 3) Tampilkan seluruh customer yang sudah meminjam lebih dari 2 kali film-film dengan kategori: 'Drama', 'Comedy', 'Horror'. 
-- 	  Tampilkan juga email, alamat, genre, dan jumlah order nya.
-- JAWAB: 
select	concat(cust.first_name,' ',cust.last_name) as fullname,
		cust.email,
		addr.address as alamat,
		cat.name as genre,
		count(r.customer_id) as 'jumlah order'
from 	rental r 
join	customer cust on cust.customer_id = r.customer_id
join	address addr on addr.address_id = cust.address_id 
join 	inventory i on i.inventory_id = r.inventory_id
join 	film f on f.film_id = i.film_id 
join 	film_category fc on fc.film_id = f.film_id 
join 	category cat on cat.category_id = fc.category_id 
where	cat.name = 'Drama' or 
		cat.name = 'Comedy'or
		cat.name = 'Horror'
group by 1, 2, 3, 4 
having count(r.customer_id) > 2;


-- 4) Tampilkan 5 kota yang menghasilkan sales tertinggi pada database ini. 
-- 	  Tampilkan juga nama negara, jumlah customer, berapa kali jumlah pinjaman nya, dan total sales yang dihasilkan.
-- JAWAB:
select 	ct.city as 'nama kota',
		c.country as 'nama negara',
		count(distinct cust.customer_id) as 'jumlah customer',
		count(r.rental_id) as 'jumlah pinjaman',
		sum(p.amount) as 'total sales'
from 	payment p 
join 	rental r on r.rental_id = p.rental_id 
join 	customer cust on cust.customer_id = r.customer_id 
join 	address addr on addr.address_id = cust.address_id
join 	city ct on ct.city_id = addr.city_id
join 	country c  on c.country_id = ct.country_id 
group by 1, 2
order by sum(p.amount) desc
limit 5;


-- 5) Tampilkan 10 customer yang menghasilkan sales tertinggi dan sales terdendah pada database ini. 
-- 	  Tampilkan juga email, alamat, kota, negara, berapa kali jumlah order nya, total sales yang dihasilkan, dan keterangan.
-- 	  Beri nama keterangan 'TOP' untuk customer yang memiliki sales tertinggi, dan 'LOW' untuk customer yang memiliki sales rendah.
-- JAWAB: 
select 	concat(cust.first_name,' ',cust.last_name) as fullname,
		cust.email,
		addr.address as alamat,
		ct.city,
		c.country as 'nama negara', 
		count(r.customer_id) as 'jumlah order',
		sum(p.amount) as 'total sales',
		(case 
			when max(p.amount) then 'TOP'
			when min(p.amount) then 'LOW'
		end) as keterangan 
from	payment p 
join	rental r on r.rental_id = p.rental_id 
join 	customer cust on cust.customer_id = r.customer_id 
join 	address addr on addr.address_id = cust.address_id 
join 	city ct on ct.city_id = addr.city_id 
join 	country c on c.country_id = ct.country_id
group by 1, 2, 3, 4, 5
order by sum(p.amount) desc
limit 10;







