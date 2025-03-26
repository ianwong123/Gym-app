<?php

/*
- Connection to Database
*/
$db_hostname = "database";
$db_database = "sgiwong";
$db_username = "root";
$db_password = getenv('DB_PASSWORD');
$db_charset = "utf8mb4";

$dsn = "mysql:host=$db_hostname;dbname=$db_database;charset=$db_charset";
$opt = array(
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false
);

try {
    $pdo = new PDO($dsn, $db_username, $db_password, $opt);
} catch (PDOException $e) {
    echo("Database connection failed: " . $e->getMessage());
}


error_reporting(E_ALL);
ini_set('display_errors', 1);


/*
 - Idea: to display only DISTINCT CLASSES (class) 
 - with AVAILABLE SLOTS (gyM_sessoin) only (at least 1).
*/
function get_available_classes($pdo) {
	
		try {
			$find_classes = $pdo -> prepare ("
				SELECT DISTINCT c.class_name
				FROM classes c
				JOIN gym_sessions g ON c.class_id = g.class_id 
				WHERE g.available_slots > 0
				ORDER BY c.class_name
			");
			
			$find_classes -> execute();
			return $find_classes -> fetchAll(PDO::FETCH_ASSOC);
			
		} catch (PDOException $e) {
			
			echo("Error fetching the classes" . $e->getMessage());
			
		}
}

$available_classes = get_available_classes($pdo);

/*
To fetch and display only AVAILABLE times for selected class 
*/
function get_available_times ($pdo, $selected_class) {
	try {
        $find_times = $pdo -> prepare("
		
			SELECT g.day_of_week, g.time_of_day 
            FROM gym_sessions g
            JOIN classes c ON g.class_id = c.class_id 
            WHERE c.class_name = ? 
            AND g.available_slots > 0
            
        ");
		
		$find_times->execute([$selected_class]);
		return $find_times->fetchAll(PDO::FETCH_ASSOC);
		
	} catch (PDOException $e) {
			
			echo("Error fetching time" . $e->getMessage());
			
		}		
}


//fFetch available times if a class is selected
$available_times = [];
if (isset($_POST['class'])) {
    $available_times = get_available_times($pdo, $_POST['class']);
}

function checkValidName($name) {
    return preg_match("/^'?[a-zA-Z][a-zA-Z '-]*[a-zA-Z]$/", $name) && !preg_match("/[-']{2,}/", $name);					
}

/*
- Phone number must start with 0
- White spaces should not be counted as a digit, removed
- Contains only 9-10 digits with numbers range 0-9 only
*/function checkValidPhone($phone) {
    $remove_white_space = str_replace(' ', '', $phone);
	return preg_match('/^0[0-9 ]{8,9}$/', $remove_white_space);

}

/*
 * Handle form logic
 */
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['class']) && empty($_POST['name']) && empty($_POST['phone'])) {

    }

    else if (isset($_POST['class']) && isset($_POST['day_time']) && isset($_POST['name']) && isset($_POST['phone'])) {
        
		$class_name = $_POST['class'];
        $day_and_time = $_POST['day_time'];
        $name = $_POST['name'];
        $phone = $_POST['phone'];

        if (!checkValidName($name)) {
            $error = "Invalid name. Name must only start with letters/apostrophe, 
                      followed by letters/hyphens, spaces. Consecutive hypens/apostrope 
                    are not allowed";
        } 
		
        elseif (!checkValidPhone($phone)) {
            $error = "Invalid phone number. Phone number must starts with a 0 and contain 
                    9 or 10 digits.";
        } 
		
        else {
            list($day, $timeOfDay) = explode(', ', $day_and_time);
            
            $fetch_classes = $pdo->prepare("SELECT class_id, capacity FROM classes WHERE class_name = ?");
            $fetch_classes->execute([$class_name]);
            $class = $fetch_classes->fetch(PDO::FETCH_ASSOC);
            
            if (!$class) {
                $error = "Class not found.";
            } 
			
            else {
                $classId = $class['class_id'];
                $fetch_gym_session = $pdo->prepare("SELECT gym_session_id, available_slots 
													 FROM gym_sessions 
													 WHERE class_id = ? 
													 AND day_of_week = ? 
													 AND time_of_day = ?");
									 
                $fetch_gym_session->execute([$classId, $day, $timeOfDay]);
                $gym_session = $fetch_gym_session->fetch(PDO::FETCH_ASSOC);
                
                if (!$gym_session) {
                    $error = "Gym session not found";
                }
				
                elseif ($gym_session['available_slots'] <= 0) {
					
                    $error = "No available slots for this gym session";
                }
                else {
                    try {
                        $pdo -> beginTransaction();
                        
						// Insert the records
                        $insert_records = $pdo->prepare("INSERT INTO bookings (gym_session_id, name, phone_number) 
															VALUES (?, ?, ?)");
                        $insert_records ->  execute([$gym_session['gym_session_id'], $name, $phone]);
                        
						// Update the available_slots that are left
                        $update_slots = $pdo->prepare("UPDATE gym_sessions 
														 SET available_slots = available_slots - 1 
														 WHERE gym_session_id = ?");
                        $update_slots -> execute([$gym_session['gym_session_id']]);
                        
                        // Fetch all of the bookings
                        $fetch_booking = $pdo->prepare("SELECT b.name, b.phone_number, b.booking_time, c.class_name 
														 FROM bookings b 
														 JOIN gym_sessions g ON b.gym_session_id = g.gym_session_id 
														 JOIN classes c ON g.class_id = c.class_id");
											 
                        $fetch_booking -> execute();
                        $bookings = $fetch_booking->fetchAll(PDO::FETCH_ASSOC);
                        
                        $pdo -> commit();
                        $success = "Booking Success.";
                        
                    } catch (PDOException $e) {
                        $pdo -> rollBack();
                        $error = "Booking failed: " . $e->getMessage();
                    }
                }
            }
        }
    }
}
?>

