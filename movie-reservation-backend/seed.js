const mongoose = require('mongoose');
const Movie = require('./models/movie');
require('dotenv').config();

mongoose.connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(async () => {
    const movie1 = new Movie({
        title: 'Inception',
        timeSlots: [
            { time: new Date('2024/10/23-15:00'), capacity: 100 },
            { time: new Date('2024/10/23-18:00'), capacity: 80 }
        ]
    });

    const movie2 = new Movie({
        title: 'Interstellar',
        timeSlots: [
            { time: new Date('2024/10/23-17:00'), capacity: 120 }
        ]
    });

    await movie1.save();
    await movie2.save();

    console.log("Movies seeded");
    process.exit();
}).catch(err => console.log(err));
