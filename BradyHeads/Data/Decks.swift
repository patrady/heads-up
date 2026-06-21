import SwiftUI

enum DeckLibrary {
    static let all: [CardDeck] = [
        CardDeck(
            name: "Animals",
            emoji: "🐘",
            color: .green,
            cards: [
                "Elephant", "Giraffe", "Penguin", "Kangaroo", "Flamingo",
                "Crocodile", "Panda", "Cheetah", "Gorilla", "Dolphin",
                "Octopus", "Eagle", "Sloth", "Meerkat", "Platypus",
                "Narwhal", "Capybara", "Axolotl", "Komodo Dragon", "Peacock"
            ]
        ),
        CardDeck(
            name: "Parks & Rec",
            emoji: "🏛️",
            color: .purple,
            cards: [
                "Leslie Knope", "Ron Swanson", "April Ludgate", "Andy Dwyer",
                "Ben Wyatt", "Chris Traeger", "Tom Haverford", "Ann Perkins",
                "Jerry Gergich", "Donna Meagle", "Li'l Sebastian", "Waffles",
                "Sweetums", "The Pit", "Pawnee", "Eagleton", "The Harvest Festival",
                "Snake Juice", "Entertainment 720", "The Cones of Dunshire"
            ]
        ),
        CardDeck(
            name: "Family Members",
            emoji: "👨‍👩‍👧‍👦",
            color: .orange,
            cards: [
                "Mom", "Dad", "Grandma", "Grandpa", "Uncle Mike",
                "Aunt Sarah", "Cousin Jake", "Baby Emma", "Uncle Tom",
                "Nana", "Pop Pop", "Sister", "Brother", "The Dog", "The Cat",
                "Aunt Karen", "Uncle Bob", "Cousin Emily", "Great Grandma", "Godfather"
            ]
        ),
        CardDeck(
            name: "Favorite Memories",
            emoji: "📸",
            color: .pink,
            cards: [
                "Beach Vacation", "Christmas Morning", "First Day of School",
                "Birthday Party", "Camping Trip", "Disney World", "Road Trip",
                "Thanksgiving Dinner", "Snow Day", "Halloween Costume",
                "Graduation", "Wedding Day", "New Year's Eve", "Game Night", "Picnic",
                "Fourth of July", "Family Reunion", "Lake House", "Movie Marathon", "Baking Cookies"
            ]
        ),
        CardDeck(
            name: "Movies",
            emoji: "🎬",
            color: .red,
            cards: [
                "Toy Story", "The Lion King", "Home Alone", "Elf", "Shrek",
                "Finding Nemo", "The Incredibles", "Frozen", "Moana", "Coco",
                "Inside Out", "Up", "Ratatouille", "WALL-E", "Encanto",
                "Jurassic Park", "Back to the Future", "Home Alone", "The Princess Bride", "Ferris Bueller"
            ]
        ),
        CardDeck(
            name: "Sports",
            emoji: "⚽",
            color: .blue,
            cards: [
                "Soccer", "Basketball", "Football", "Baseball", "Tennis",
                "Swimming", "Gymnastics", "Volleyball", "Golf", "Hockey",
                "Track and Field", "Bowling", "Skiing", "Surfing", "Cycling",
                "Rock Climbing", "Ping Pong", "Archery", "Rowing", "Fencing"
            ]
        ),
        CardDeck(
            name: "Pop Culture",
            emoji: "⭐",
            color: Color(red: 0.9, green: 0.6, blue: 0.1),
            cards: [
                "Taylor Swift", "Netflix", "TikTok", "Beyoncé", "SpongeBob",
                "Minecraft", "Fortnite", "The Avengers", "Harry Potter", "Star Wars",
                "The Office", "Friends", "Game of Thrones", "Breaking Bad", "Stranger Things",
                "BTS", "Billie Eilish", "Elon Musk", "The Super Bowl", "The Oscars"
            ]
        ),
        CardDeck(
            name: "Food",
            emoji: "🍕",
            color: Color(red: 0.8, green: 0.3, blue: 0.1),
            cards: [
                "Pizza", "Sushi", "Tacos", "Cheesecake", "Ramen",
                "Cheeseburger", "Lasagna", "Guacamole", "Fried Chicken", "Pancakes",
                "Mac and Cheese", "Grilled Cheese", "Hot Dog", "Nachos", "Burritos",
                "Waffles", "Chocolate Cake", "Ice Cream Sundae", "Lobster", "Cinnamon Roll"
            ]
        ),
        CardDeck(
            name: "Geography",
            emoji: "🌍",
            color: .teal,
            cards: [
                "Eiffel Tower", "Amazon River", "Tokyo", "Grand Canyon", "Niagara Falls",
                "Great Wall of China", "Mount Everest", "Sahara Desert", "Great Barrier Reef", "Machu Picchu",
                "Times Square", "Big Ben", "Sydney Opera House", "Colosseum", "Taj Mahal",
                "Amazon Rainforest", "Iceland", "New Zealand", "Antarctica", "The Nile"
            ]
        ),
        CardDeck(
            name: "Music",
            emoji: "🎵",
            color: Color(red: 0.3, green: 0.1, blue: 0.7),
            cards: [
                "The Beatles", "Guitar", "Drum Solo", "Michael Jackson", "Elvis Presley",
                "Piano", "Jazz", "Hip Hop", "Rock and Roll", "Opera",
                "Ed Sheeran", "Adele", "Drake", "Eminem", "Whitney Houston",
                "Violin", "Trumpet", "DJ", "Music Festival", "Boy Band"
            ]
        )
    ]
}
