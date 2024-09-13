const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();
const port = 3000;

// Middleware to parse JSON bodies
app.use(express.json());

// Path to the JSON file
const dataFilePath = path.join(__dirname, 'data.json');

// Helper function to read data from the file
const readData = () => {
  try {
    const data = fs.readFileSync(dataFilePath, 'utf8');
    return JSON.parse(data);
  } catch (err) {
    console.error('Error reading data:', err);
    return [];
  }
};

// Helper function to write data to the file
const writeData = (data) => {
  try {
    fs.writeFileSync(dataFilePath, JSON.stringify(data, null, 2));
  } catch (err) {
    console.error('Error writing data:', err);
  }
};

// GET all employees
app.get('/employees', (req, res) => {
  const employees = readData();
  res.json(employees);
});

// POST a new employee
app.post('/employees', (req, res) => {
  const newEmployee = req.body;
  const employees = readData();

  // Basic validation
  if (!newEmployee.id || !newEmployee.name || !newEmployee.position || !newEmployee.department) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  // Check if employee with the same ID already exists
  const existingEmployee = employees.find(emp => emp.id === newEmployee.id);
  if (existingEmployee) {
    return res.status(400).json({ error: 'Employee with this ID already exists' });
  }

  employees.push(newEmployee);
  writeData(employees);
  res.status(201).json(newEmployee);
});

// PUT (update) an employee by ID
app.put('/employees/:id', (req, res) => {
  const employeeId = req.params.id;
  const updatedData = req.body;
  const employees = readData();

  const employeeIndex = employees.findIndex(emp => emp.id === employeeId);
  if (employeeIndex === -1) {
    return res.status(404).json({ error: 'Employee not found' });
  }

  employees[employeeIndex] = { ...employees[employeeIndex], ...updatedData };
  writeData(employees);
  res.json(employees[employeeIndex]);
});

// DELETE an employee by ID
app.delete('/employees/:id', (req, res) => {
  const employeeId = req.params.id;
  const employees = readData();

  const employeeIndex = employees.findIndex(emp => emp.id === employeeId);
  if (employeeIndex === -1) {
    return res.status(404).json({ error: 'Employee not found' });
  }

  employees.splice(employeeIndex, 1);
  writeData(employees);
  res.status(200).send(`Employee with id ${employeeId} deleted.`);
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
