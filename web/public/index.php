<?php
include 'gym.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gym Sessions Booking System</title>
</head>

<body>
    <h1>Gym Sessions Booking</h1>
    <?php if (isset($error)): ?>
        <p style  = "color: red;"><?php echo $error; ?></p>
    <?php endif; ?>
	
    <?php if (isset($success)): ?>
	
        <p style =  "color: green;"><?php echo $success; ?></p>
        <h2>Bookings:</h2>
        <table border="1">
            <tr>
                <th>Name</th>
                <th>Phone Number</th>
                <th>Class</th>
				<th>Booking Time</th>
            </tr>
            <?php foreach ($bookings as $booking): ?>
                <tr>
                    <td><?php echo $booking['name']; ?></td>
                    <td><?php echo $booking['phone_number']; ?></td>
                    <td><?php echo $booking['class_name']; ?></td>
					<td><?php echo $booking['booking_time']; ?></td>
                </tr>
            <?php endforeach; ?>
        </table>
    <?php endif; ?>
	
    <form action = "index.php" method = "POST">
        <label for = "class">Gym Classes:</label>
        <select name = "class" id = "class" required onchange = "submit()">
            <option value = "">-- Select an option --</option>
			<?php foreach ($available_classes as $class): ?>
				<option value = "<?php echo htmlspecialchars ($class['class_name']); ?>"
					<?php echo (isset($_POST['class']) && $_POST['class'] === $class['class_name']) ? 'selected' : ''; ?>>
					<?php echo htmlspecialchars($class['class_name']); ?>
				</option>
			<?php endforeach; ?>
			
        </select><br>
        <label for = "day_time">Day and Time:</label>
        <select name = "day_time" id="day_time" required>
            <option value = "">-- Select an option --</option>
				<?php foreach ($available_times as $time): ?>
					<option value = "<?php echo htmlspecialchars ($time['day_of_week'] . ', ' . $time['time_of_day']); ?>">
						<?php echo htmlspecialchars ($time['day_of_week'] . ', ' . $time['time_of_day']); ?>
					</option>
				<?php endforeach; ?>
        </select><br>

        <label for = "name">Name:</label>
        <input type = "text" name = "name" id = "name" required><br>

        <label for = "phone">Phone Number:</label>
        <input type = "text" name = "phone" id = "phone" required><br>

        <button type = "submit">Submit</button>
    </form>
	
</body>
</html>
