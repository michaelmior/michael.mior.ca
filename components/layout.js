  import Head from 'next/head'
import Image from 'next/image'
import Link from 'next/link'

export default function Layout({ children, home }) {
  return (
    <div>
      <Head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width" />
        <meta name="theme-color" content="#4080c0" />
        <meta property="fb:admins" content="227200130" />
        <link rel="apple-touch-icon" sizes="57x57" href="/favicons/apple-touch-icon-57x57.png" />
        <link rel="apple-touch-icon" sizes="60x60" href="/favicons/apple-touch-icon-60x60.png" />
        <link rel="apple-touch-icon" sizes="72x72" href="/favicons/apple-touch-icon-72x72.png" />
        <link rel="apple-touch-icon" sizes="76x76" href="/favicons/apple-touch-icon-76x76.png" />
        <link rel="apple-touch-icon" sizes="114x114" href="/favicons/apple-touch-icon-114x114.png" />
        <link rel="apple-touch-icon" sizes="120x120" href="/favicons/apple-touch-icon-120x120.png" />
        <link rel="apple-touch-icon" sizes="144x144" href="/favicons/apple-touch-icon-144x144.png" />
        <link rel="apple-touch-icon" sizes="152x152" href="/favicons/apple-touch-icon-152x152.png" />
        <link rel="apple-touch-icon" sizes="180x180" href="/favicons/apple-touch-icon-180x180.png" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
        <meta name="apple-mobile-web-app-title" content="Michael Mior" />
        <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png" />
        <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png" />
        <link rel="shortcut icon" href="/favicons/favicon.ico" />
      </Head>
      <div id="blm">
        #BlackLivesMatter <a href="https://support.eji.org/give/153413/#!/donation/checkout">Support the Equal Justice Initiative</a>
      </div>
      <header>
        <div className="content-wrap">
          <div className="logo">
            <h1><a href="https://michael.mior.ca">Michael Mior</a></h1>
          </div>
        </div>
      </header>
      <div id="logo"><img alt="Logo" src="/img/logo.png" width="280" height="300" /></div>

      <div id="content">
        <div class="content-wrap">
          <hr />
          <ul class="menu">
            <li><a href="/">Home</a></li>
            <li><a href="/about/">About Me</a></li>
            <li><a href="/contact/">Contact</a></li>
            <li><a href="/blog/">Blog</a></li>
            <li><a href="/publications/">Publications</a></li>
            <li><a href="/projects/">Projects</a></li>
          </ul>
          <hr />
          {children}
        </div>
      </div>
      <footer>
        <div class="content-wrap">
          <section class="copy">
            <p>&#xA9; 2021 Michael Mior</p>
          </section>
        </div>
      </footer>
    </div>
  )
}
