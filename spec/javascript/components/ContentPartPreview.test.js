import React from 'react';
import ReactDOM from 'react-dom';

import { mount, configure } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
configure({ adapter: new Adapter() });

import ContentPartPreview from 'components/ContentPartPreview';

test('rendered component', () => {
  const wrapper = mount(<ContentPartPreview
    image={null}
    id={1}
    name={'test-name'}
    onClick={null}
  />);
  // look for the name
  expect(wrapper.debug()).toContain('name="test-name"');
});

