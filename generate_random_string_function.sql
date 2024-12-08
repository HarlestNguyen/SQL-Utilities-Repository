-- Tạo bảng chứa các ký tự thường (char)
CREATE TEMPORARY TABLE temp_lowercase_characters (
    _char CHAR(1) PRIMARY KEY
);

-- Tạo bảng chứa các ký tự đặc biệt (spec_char)
CREATE TEMPORARY TABLE temp_special_characters (
    _spec_char CHAR(1) PRIMARY KEY
);

-- Tạo bảng chứa các ký tự in hoa (uppercase_char)
CREATE TEMPORARY TABLE temp_uppercase_characters (
    _uppercase_char CHAR(1) PRIMARY KEY
);

-- Tạo bảng chứa các số (number)
CREATE TEMPORARY TABLE temp_numbers (
    _number CHAR(1) PRIMARY KEY
);

-- Chèn dữ liệu vào bảng ký tự thường
INSERT INTO temp_lowercase_characters (_char) VALUES
('a'), ('b'), ('c'), ('d'), ('e'), ('f'), ('g'), ('h'), ('i'), ('j'),
('k'), ('l'), ('m'), ('n'), ('o'), ('p'), ('q'), ('r'), ('s'), ('t'),
('u'), ('v'), ('w'), ('x'), ('y'), ('z');

-- Chèn dữ liệu vào bảng ký tự đặc biệt
INSERT INTO temp_special_characters (_spec_char) VALUES
('!'), ('@'), ('#'), ('$'), ('%'), ('^'), ('&'), ('*'), ('('), (')'),
('_'), ('+'), ('='), ('{'), ('}'), ('['), (']'), (':'), (';'), ("'"), ('"'),
('<'), ('>'), ('?'), (','), ('.'), ('/'), ('|'), ('\\'), ('~');

-- Chèn dữ liệu vào bảng ký tự in hoa
INSERT INTO temp_uppercase_characters (_uppercase_char) VALUES
('A'), ('B'), ('C'), ('D'), ('E'), ('F'), ('G'), ('H'), ('I'), ('J'),
('K'), ('L'), ('M'), ('N'), ('O'), ('P'), ('Q'), ('R'), ('S'), ('T'),
('U'), ('V'), ('W'), ('X'), ('Y'), ('Z');

-- Chèn dữ liệu vào bảng số
INSERT INTO temp_numbers (_number) VALUES
('0'), ('1'), ('2'), ('3'), ('4'), ('5'), ('6'), ('7'), ('8'), ('9');

-- Tạo hàm tạo chuỗi tự động
DELIMITER $$

CREATE FUNCTION generate_random_string(num_of_char INT, 
    include_char BOOLEAN,           -- Có sử dụng ký tự thường không
    include_spec_char BOOLEAN,      -- Có sử dụng ký tự đặc biệt không
    include_uppercase_char BOOLEAN, -- Có sử dụng ký tự in hoa không
    include_number BOOLEAN          -- Có sử dụng ký tự số không
) 
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255) DEFAULT '';
    DECLARE i INT DEFAULT 1;
    DECLARE rand_index INT;

	IF num_of_char < 8 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The length of the string must be at least 8 characters';
	END IF;
    -- Kiểm tra nếu tất cả các điều kiện đều false
    IF NOT include_char AND NOT include_spec_char AND NOT include_uppercase_char AND NOT include_number THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'At least one character type must be included (char, special char, uppercase char, or number)';
    END IF;
    
    WHILE i <= n DO
        SET rand_index = FLOOR(1 + RAND() * 4);  -- Ngẫu nhiên chọn cột từ 4 bảng
        
        -- Chọn ngẫu nhiên ký tự từ cột tương ứng
        IF rand_index = 1 AND include_char THEN
            SET result = CONCAT(result, (SELECT _char FROM temp_lowercase_characters ORDER BY RAND() LIMIT 1));
        ELSEIF rand_index = 2 AND include_uppercase_char THEN
            SET result = CONCAT(result, (SELECT _uppercase_char FROM temp_uppercase_characters ORDER BY RAND() LIMIT 1));
        ELSEIF rand_index = 3 AND include_spec_char THEN
            SET result = CONCAT(result, (SELECT _spec_char FROM temp_special_characters ORDER BY RAND() LIMIT 1));
        ELSEIF rand_index = 4 AND include_number THEN
            SET result = CONCAT(result, (SELECT _number FROM temp_numbers ORDER BY RAND() LIMIT 1));
        END IF;

        SET i = i + 1;
    END WHILE;

    RETURN result;
END $$

DELIMITER ;

-- Sử dụng hàm                số lượng  ký tự thường     ký tự đặc biệt     ký tự in hoa     ký tự số
select generate_random_string(10      , true           , true             , true           , true);
-- test case
select generate_random_string(10, false, false, false, false);
select generate_random_string(6, true, false, false, false);