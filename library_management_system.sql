create database library_management_system;
use library_management_system;
create table authors(auther_id int primary key auto_increment,name varchar(50),country varchar(50));
INSERT INTO Authors (name, country) VALUES
('J.K. Rowling', 'United Kingdom'),
('George Orwell', 'United Kingdom'),
('Harper Lee', 'United States'),
('Chetan Bhagat', 'India'),
('Yuval Noah Harari', 'Israel');

create table books(book_id int primary key auto_increment,title varchar(50),auther_id int,genre varchar(50),published_year date,copies_total int,copies_available int,foreign key(auther_id) references authors(auther_id));
INSERT INTO Books (title, author_id, genre, published_year, copies_total, copies_available) VALUES
('Harry Potter and the Sorcerer''s Stone', 1, 'Fantasy', 1997, 10, 6),
('1984', 2, 'Dystopian', 1949, 8, 5),
('Animal Farm', 2, 'Political Satire', 1945, 6, 2),
('To Kill a Mockingbird', 3, 'Classic', 1960, 7, 4),
('Five Point Someone', 4, 'Fiction', 2004, 5, 3),
('Sapiens: A Brief History of Humankind', 5, 'History', 2011, 9, 7);
alter table books change column auther_id author_id int;
alter table books modify published_year year;

create table members(member_id int primary key auto_increment,name varchar(50),email varchar(50),phone bigint,address varchar(200),join_date date);
INSERT INTO Members (name, email, phone, address, join_date) VALUES
('Amit Sharma', 'amit.sharma@email.com', '9876543210', 'Pune, India', '2023-01-15'),
('Priya Verma', 'priya.verma@email.com', '8765432109', 'Mumbai, India', '2023-03-10'),
('John Doe', 'john.doe@email.com', '7654321098', 'New York, USA', '2023-05-20'),
('Sara Khan', 'sara.khan@email.com', '6543210987', 'Delhi, India', '2023-07-12'),
('Michael Smith', 'michael.smith@email.com', '5432109876', 'London, UK', '2023-08-05');

create table borrowed_books(borrow_id int primary key auto_increment,member_id int,book_id int,borrow_date date,due_date date,return_date date,foreign key(member_id) references members(member_id),foreign key(book_id) references books(book_id));
INSERT INTO Borrowed_Books (member_id, book_id, borrow_date, due_date, return_date) VALUES
(1, 1, '2023-07-01', '2023-07-15', '2023-07-10'),
(2, 2, '2023-07-05', '2023-07-20', NULL),
(3, 3, '2023-07-10', '2023-07-25', '2023-07-24'),
(4, 4, '2023-07-12', '2023-07-27', NULL),
(5, 5, '2023-07-15', '2023-07-30', '2023-07-29'),
(1, 6, '2023-08-01', '2023-08-16', NULL);

create table fines(fine_id int primary key auto_increment,borrow_id int,amount decimal(6,2),status enum("unpaid","paid"),foreign key(borrow_id) references borrowed_books(borrow_id));
INSERT INTO Fines (borrow_id, amount, status) VALUES
(2, 50.00, 'Unpaid'),
(4, 30.00, 'Unpaid'),
(6, 20.00, 'Paid');

select b.title,m.name,datediff(curdate(),bb.due_date) as overdue,datediff(curdate(),bb.due_date)*10 as fine from Borrowed_Books bb 
join members m on bb.member_id=m.member_id
join books b on b.book_id =bb.book_id
WHERE bb.return_date IS NULL
AND bb.due_date < CURDATE();

select b.title,COUNT(bb.borrow_id) AS times_borrowed
from books b join Borrowed_Books bb on b.book_id=bb.book_id
group by b.title
order by times_borrowed desc
limit 1;

select m.name,COUNT(bb.borrow_id) AS total_borrowed,
    RANK() OVER (ORDER BY COUNT(bb.borrow_id) DESC) AS borrow_rank
FROM Members m
JOIN Borrowed_Books bb ON m.member_id = bb.member_id
GROUP BY m.member_id, m.name
ORDER BY total_borrowed DESC;

CREATE VIEW Available_Books AS
SELECT 
    book_id,
    title,
    genre,
    published_year,
    copies_total,
    copies_available
FROM Books
WHERE copies_available > 0;
select * from Available_Books;
