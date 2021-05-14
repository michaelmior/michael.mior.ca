import Head from 'next/head'
import Layout from '../components/layout'

export default function Home() {
  return (
    <Layout>
      <p class="h-card">
        You&apos;ve reached the personal website of <a rel="me" href="https://michael.mior.ca/" class="p-name u-url">Michael Mior</a>.
        I&apos;m an Assistant Professor in the Computer Science Department at the <a href="https://www.cs.rit.edu/">Rochester Institute of Technology</a>.
        I received my PhD from the <a href="https://cs.uwaterloo.ca/">David R. Cheriton School of Computer Science</a> at the <a href="https://uwaterloo.ca/">University of Waterloo</a>.
        To get in touch, send me an <a rel="me" href="mailto:michael@mior.ca" class="u-email">email</a> and we&apos;ll talk.(Students should contact me using my <a href="mailto:mmior@cs.rit.edu">RIT email</a>.)
      </p>
    </Layout>
  )
}
