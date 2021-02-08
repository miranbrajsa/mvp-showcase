## Architecture overview
The pattern used is MVP. Major architecture modules are explained below.

### Storyboards vs XIBs
Personally, I prefer XIBs over Storyboards for the sole fact of being able to create custom initializers. In the assignment, they were used to provide the view controllers with their respective presenters.

### Navigation service
This service is responsible for providing the initial view controller to our application's window. It's a simple use case here, so we just provide the one and only view controller. In a real product, the navigation service would hold a reference to an authorization service, which would tell it if a user is logged in or not. In the latter case, the navigation service would give our application window a starting view controller for a login flow. However, if a user is currently logged in, it would provide a last viewed view controller, last opened tab, or whatever UX decision-based view should be displayed.

### DataStore
The data store is a protocol with specific inheriting protocols for each of the responsibilities.

#### Back-end API Store
The store used to contact the API for the live application.

#### Test Mockup Store
The store used in unit tests which reads from the bundled-in JSON.

## Improvement considerations

### Security

Back-end API, as it probably is the case in the real-world application, should be exposed via HTTPS instead of an HTTP protocol. It should also require an authorization token (or another authentication method). Putting the API behind an SSL/TLS would also allow the iOS app to block communication with all non-secure resources.

### BackendAPIStore

#### Authentication token

In a real-world scenario, we'd initialize the store with an authentication token allowing us to talk to the back-end services.

#### Caching

We'd also probably want to cache the back-end responses if a user gets disconnected from the network. This would allow her/him to continue working and browsing through the last fetched results.

#### Better error handling

We're currently simply ignoring all network errors and just return an empty result set.

We should implement a retry mechanism telling us whether a user lost a network connection, whether a timeout occurred, or something similar.  In cases of a recoverable error, such as a timeout, we should have a retry count defined saying how many times we should re-execute the query before failing with an error.

### UI/UX
The following are UX/UI improvements that could be implemented:

* iPhone/iPad specific layouts
* Portrait orientation (currently locked to landscape as per initial design)