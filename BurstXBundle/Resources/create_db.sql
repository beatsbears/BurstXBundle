CREATE DATABASE burstwallet; 
CREATE USER 'burstwallet'@'localhost' IDENTIFIED BY 'PASSWORD'; 
GRANT ALL PRIVILEGES ON burstwallet.* TO 'burstwallet'@'localhost';
