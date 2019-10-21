// Run this example by adding <%= javascript_pack_tag 'development' %> to the head of your layout file,
// like app/views/layouts/application.html.erb.

import React from 'react'
import ReactDOM from 'react-dom'

// Use axe a11y testing in development.
var axe = require('react-axe');

if (process.env.NODE_ENV !== 'production') {
  document.addEventListener('DOMContentLoaded', () => {
    axe(React, ReactDOM, 1000);
  });
}
