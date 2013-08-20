BOS2013 (née ArtsFest)
======================

I developed ArtsFest for two purposes: first, as a learning aid for an eBook I want to write on app development, and second, to serve as the official app for Bushwick Open Studios, the annual arts festival in the Bushwick neighborhood of Brooklyn, New York. Still not sure if I'll ever finish the ArtsFest book, but the Bushwick Open Studios app served up schedules and maps to over 3,000 festivalgoers in June of 2013. 

The BOS app for 2013 was comprised of a Python backend for storing information about the three-day arts festival, and a native mobile client for viewing the schedules and events. 

The web service is read-only; it uses Flask and SQLAlchemy to expose a JSON interface to event data stored in a SQLite database. Storing this data in a SQLite database wasn't perfect; it meant pushing an update to Heroku whenever we wanted to update events. It worked for us, though, since there were few updates required and we could batch them all at once. It would be trivial to move this over to a PostgreSQL solution if you wanted to. 

The iPhone app consumes data from this web service and stores it in a local Core Data store for offline access. It allows users to browse events by category or day, view maps and details about open studios and events, and visit the websites of the BOS 2013 sponsors. Some highlights: 

 * Map annotation views render map numbers on the fly, so every point on the map has a number that corresponds to the printed map and door signs posted throughout the neighborhood. 
 * Map symbols also light up in pink when the space is open, and turn black when the space is closed. 
 * In the neighborhood, list views update the distance to nearby studios in real time; during the weekend, a "Today" button allows users to scroll to the current day. 
 * Efficient use of Core Data keeps the fetched results controller in a base class; view controllers need only specify what model they're interested in to get a fully functional Core Data driven table view. 

You can run the iPhone app right off the bat; it still connects to the backend hosted on Heroku. You can also run the server locally; set up a virtual environment, install your requirements with pip and ```runserver.py```. Feel free to use this code to run your own arts festival, music showcase, or generally anything else involving people in places at times. Although I should mention, please don't use the BOS logo or identity and pass it off as your own; that would be pretty lame. 

 \- Joey Castillo
