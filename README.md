# JustDropIt

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
JustDropIt is an app that allows you to anonymously post comments about your classes and professors.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Education, Music, Reference, Social Networking
- **Mobile:** iOS
- **Story:** The app allows university students to choose the right classes to set a strong base for their future. 
- **Market:** University Students
- **Habit:** As a social media application, this app will attract teenagers to gossip about their professors often.
- **Scope:** All students

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Login Screen
* Connect to parse
* Home view
* Search view
* Professor view
* Create view
* User can post
* User can reset

**Optional Nice-to-have Stories**

* Spotify Songs
* Commenting on posts

### 2. Screen Archetypes

* Login Screen
   * Icon and Title
   * Dropdown list of Universities
   * Enter Button
* Home View
   * Table of posts
   * Navbar with Title, Settings and Search icons
   * Posts with Professor, Text, Upvotes and upvotes buttons
* Search View
    * Search bar
    * Table view of professors with create button
* Professor View
    * Professor name
    * Table view with posts
* Create View
    * Professor name
    * Text field
    * Post button

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Settings tab to settings view
* Search tab to search view
* Name tab to Home view

**Flow Navigation** (Screen to Screen)

* Search view
   * Professor view of selected professor
   * Create view of selected professor

## Wireframes
![](https://i.imgur.com/gnipK6p.jpg)


### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 


### Models
#### Post
| Property | Type | Description |
| -------- | -------- | -------- |
| ObjectID     | String     | Unique id for the user post     |
| Author | Pointer to User | Song that user posts |
| Media | file | Song Object that user includes |
| Caption | String | Song caption by author |
| CommentCount | integer | NNumber of comments made to the post |
| Likes | integer | Number of likes |
| createdAt | DateTime | Name of author |
| Author | Pointer to User | Date when post was created |
| Comments | Pointer to Comments | Comments on the post |

#### Professor
| Property | Type | Description |
| -------- | -------- | -------- |
| ProfessorName     | String     | Name of professor |
| Posts | Pointer to Posts | Posts mentioning the professor |
| PostCount | integer | Number of posts on Professor |

#### User
| Property | Type | Description |
| -------- | -------- | -------- |
| Username     | String     | Username |
| Posts | Pointer to Posts | Posts |
| PostCount | integer | Number of posts on Professor |


### Networking

* Login Screen
    * (Read/Get) Query University names
* Settings Screen
    * (Read/Get) Query user object
    * (Delete) Delete existing user object
    * (Update) Update user information
* Home Screen
    * (Read/GET) Query all university names
    * (Read/GET) Query all professor/faculty objects
    * (Create/POST) Add Like to post
    * (Delete) Delete existing like on post
    * (Create/POST) Add Comment to post
    * (Delete) Delete existing comment on post
* Create Screen
    * (Read/Get) Query Professor name
    * (Create/POST) Create a new post object

```
// Objects

Let university = PFObject(className: “University”)
university[“schools”] = “Hello World”
university.saveInBackground { (succeeded, error) in
	If (succedded) {
		// the object had been saved.
	} else { 
		// there was problem
        }
}

let profs = PFObject(className: “Prof”)
Profs[“prof”] = “Dr. Doolittle”
profs.saveInBackGround { (succeeded, error) in
	If (succedded) {
		// the object had been saved.
	} else { 
		// there was problem
        }
}

let posts = PFObject(className: Posts)
Posts[“posts”] = “Hi”
Post[“author”] = “User123456789”
Post[“CreatedBy”] = “Mar 5”
posts.saveInBackground { (succeeded, error) in
	If (succedded) {
		// the object had been saved.
	} else { 
		// there was problem
        }
}

// Queries

// IOS
// (Read/GET) Query all university names
let queryA = PFQuery(className: “University”)
query.whereKey(“university”, equalTo currentUniversity)
query.order(byAscending: “Name”)
query.findObjectsInBackground {(schools: [PFObject]?, error: Error?) in
	If let error = error {
		print (error.localizedDescription)
	} else if let schools = schools {
		print(“Successfully retrieved \(school.count) schools.”)
        }
}

// ios
// (Read/GET) Query all professors in university
let queryB = PFQuery(className: “Prof”)
query.whereKey(“prof”, equalTo currentProfessor)
query.order(byAscending: “Name”)
query.findObjectsInBackground {(profs: [PFObject]?, error: Error?) in
	If let error = error {
		print (error.localizedDescription)
	} else if let profs = profs {
		print(“Successfully retrieved \(profs.count) professors.”)
        }
}

// ios
// (Read/GET) Query all posts under the profs name
let queryC = PFQuery(className: “Posts”)
query.whereKey(“prof”, equalTo currentProfessor)
query.order(byDescending: “createdBy”)
query.findObjectsInBackground {(posts: [PFObject]?, error: Error?) in
	If let error = error {
		print (error.localizedDescription)
	} else if let posts = posts {
		print(“Successfully retrieved \(posts.count) post.”)
        }
}
```



