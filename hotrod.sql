CREATE TABLE IF NOT EXISTS vehicle_shake (
    plate VARCHAR(20) NOT NULL PRIMARY KEY, -- License plate of the vehicle
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp of when the shaky module was applied
);
