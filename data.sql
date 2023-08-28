CREATE TABLE `blips` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
    `sprite` INT(11) NOT NULL,
    `position` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
    `openTime` INT(11) NOT NULL DEFAULT '8',
    `closeTime` INT(11) NOT NULL DEFAULT '20',
    `openColor` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
    `closeColor` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `name` (`name`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=17
;