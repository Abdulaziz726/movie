const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const Movie = require('./models/movie');
require('dotenv').config();
const port = process.env.PORT || 3000;
const app = express();
app.use(bodyParser.json());
app.use(cors());

// MongoDB connection
mongoose.connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => {
    console.log("MongoDB connected.");
}).catch((err) => {
    console.log(err);
});

// Get all movies
app.get('/api/movies', async (req, res) => {
    const movies = await Movie.find();
    res.json(movies);
});

// Check availability for a specific time slot
app.get('/api/movies/:movieId/slots/:slotId/availability', async (req, res) => {
    const movie = await Movie.findById(req.params.movieId);
    const timeSlot = movie.timeSlots.id(req.params.slotId);
    const remainingCapacity = timeSlot.capacity - timeSlot.booked;
    res.json({ remainingCapacity });
});

// Reserve seats for a time slot
app.post('/api/movies/:movieId/slots/:slotId/reserve', async (req, res) => {
    const movie = await Movie.findById(req.params.movieId);
    const timeSlot = movie.timeSlots.id(req.params.slotId);
    const seatsToReserve = req.body.numberOfSeats;


    if (timeSlot.booked + seatsToReserve > timeSlot.capacity) {
        return res.status(400).json({ message: 'Not enough seats available.' });
    }
   
    else{
    timeSlot.booked += seatsToReserve;
    await movie.save();

    res.json({ message: 'Reservation successful.' });}
});

app.listen(port, () => {
    console.log("Server is running on port "+port);
});
