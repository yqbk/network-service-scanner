import React from 'react';
import TestUtils from 'react-addons-test-utils';
import expect from 'expect';
import Main from './main';

describe('Main', () => {
  const component = TestUtils.renderIntoDocument(<Main/>);

  it('renders', () => {
    expect(TestUtils.findRenderedComponentWithType(component, Main)).toExist();
  });
});
