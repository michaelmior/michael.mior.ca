import Head from 'next/head'
import Layout from '../components/layout'

const bookingJS = `
  window.timekitBookingConfig = {
    name: 'Michael',
    email: 'michael@mior.ca',
    app: 'mmior-personal',
    apiToken: 'cdTKphJOM10rawT7qNT1RuCHNYbqSHLe',
    calendar: '86a13284-c780-4555-9625-1187815fe793',
    avatar: 'https://pbs.twimg.com/profile_images/471677968436060160/OMCoxD4Q_400x400.jpeg',
    timekitFindTime: {
      filters: {
        and: [
          {business_hours:{}},
          {exclude_weekend:{}}
        ]
      }
    }
  }
`;

export default function About() {
  return (
    <Layout>
      <h2>Email:&#xA0;<a href="mailto:michael@mior.ca">michael@mior.ca</a></h2>
      <p>RIT students (or potential students) should contact me at <a href="mailto:mmior@cs.rit.edu">mmior@cs.rit.edu</a> instead of using the form below.</p>
      <h2>Book a meeting</h2>
      <div id="bookingjs">
        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script type="text/javascript" src="//cdn.timekit.io/booking-js/v1/booking.min.js" defer></script>
        <script type="text/javascript" dangerouslySetInnerHTML={{__html: bookingJS}}></script>
      </div>
    </Layout>
  )
}
