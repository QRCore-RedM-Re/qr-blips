CREATE TABLE blips (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    sprite INT,
    coord_x FLOAT,
    coord_y FLOAT,
    coord_z FLOAT,
    opentime INT,
    closetime INT,
    opencolor VARCHAR(255),
    closecolor VARCHAR(255)
);
