DROP TABLE IF EXISTS samples;

CREATE TABLE samples (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name TEXT NOT NULL
) charset=utf8;
 
INSERT INTO samples (name) VALUES ("桜井"),("稲葉"),("槇原");