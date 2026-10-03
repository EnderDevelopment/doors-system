CREATE TABLE IF NOT EXISTS doors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    coords VARCHAR(100) NOT NULL,
    price INT DEFAULT 500,
    locked BOOLEAN DEFAULT TRUE
);

INSERT INTO doors (owner, model, coords, price, locked) VALUES ('admin', 'prop_door_01', '{"x": -100.0, "y": -200.0, "z": 30.0}', 500, TRUE);