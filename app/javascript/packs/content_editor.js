// This is the main entrypoint for the Content Editor.

import React from 'react'
import ReactDOM from 'react-dom'
import WebpackerReact from 'webpacker-react'

import ContentEditor from 'components/ContentEditor'

WebpackerReact.setup({ContentEditor})
