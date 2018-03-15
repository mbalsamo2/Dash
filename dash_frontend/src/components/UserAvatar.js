import React from 'react'
import { connect } from 'react-redux'
import { fetchEvent } from '../actions/events'


const UserAvatar = (props) => {
  const SortEvents = (events) => {
    events.sort(function(a, b) {
      a = new Date(a.start_time)
      b = new Date(b.start_time)
      return a > b ? 1 : a < b ? -1 : 0
    })
    return events
  }

  const FilterEvents = (events) => {
    const filterEvents = events.filter(event => {
      return event.invite[0].status === "confirmed"
    })
    return filterEvents
  }

  const FirstThree = (events) => {
    return events.slice(0, 3)
  }

  const findEvent = (id) => {
    props.fetchEvent(id)
  }


  const events = SortEvents(props.user.events)
  const upcomingEvents = FilterEvents(events)
  const topThreeEvents = upcomingEvents.length > 3 ? FirstThree(upcomingEvents) : upcomingEvents

  return (
    <div>
      <img src={props.user.photo}  alt={props.user.name} />
      <h5>Welcome Back, {props.user.name}</h5>
      <div>
        <h5>Your Upcoming Events</h5>
        {topThreeEvents.map(event => {
          return <h5 onClick={() => {findEvent(event.id)}} key={event.id}>{event.title}</h5>
        })}
      </div>
    </div>
  )
}

function mapStateToProps(state) {
  return {
    user: state.user
  }
}

// function mapDispatchToProps(dispatch) {
//   return {
//     fetchEvent: fetchEvent
//   }
// }

export default connect(mapStateToProps, { fetchEvent })(UserAvatar)