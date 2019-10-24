// This is the main entrypoint for Braven Platform.
// Things that need to be set up globally go here.
// Run this script by adding <%= javascript_pack_tag 'platform' %> to the head of your layout file,
// like app/views/layouts/application.html.erb.

import React from 'react'
import ReactDOM from 'react-dom'

// Use axe a11y testing in development.
if (process.env.NODE_ENV !== 'production') {
  let axe = require('react-axe');
  document.addEventListener('DOMContentLoaded', () => {
    axe(React, ReactDOM, 1000);
  });
}
