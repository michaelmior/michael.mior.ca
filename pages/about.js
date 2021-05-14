import Head from 'next/head'
import Layout from '../components/layout'

export default function About() {
  return (
    <Layout>
      <p>
        I was born in the small town of Bobcaygeon, Ontario (home of the amazing <a href="http://kawarthadairy.com/">Kawartha Dairy</a>!)
        After graduating from high school, I was persuaded by the founding President to join the first class of computer science students at the <a href="https://uoit.ca/">University of Ontario Institute of Technology (UOIT)</a>.
        While there, I spent some time building <a href="https://news.uoit.ca/archives/2006/12/20061215_1.php">solar cars</a> among other things.
      </p>
      <p>
        I then made my way to the <a href="http://web.cs.toronto.edu/">Department of Computer Science</a> at the University of Toronto to complete my Masters with Professor <a href="http://www.cs.toronto.edu/~delara/">Eyal de Lara</a>.
        My research revolved around scaling databases using the <a href="http://sysweb.cs.toronto.edu/projects/1">SnowFlock project</a>.
        I graduated in February 2011 and spent some time working in the startup scene in Toronto and Montreal.
        I then completed my PhD in the <a href="https://uwaterloo.ca/data-systems-group/">Data Systems Group</a> computer science at the University of Waterloo under the supervision of Professor <a href="https://cs.uwaterloo.ca/~kmsalem/">Ken Salem</a>.
        As of August 2018, I have joined the faculty at the <a href="https://www.cs.rit.edu/">Rochester Institute of Technology</a> as an Assistant Professor.
        This site contains some information on <a href="/projects/">projects I have worked on</a>.
      </p>
    </Layout>
  )
}
