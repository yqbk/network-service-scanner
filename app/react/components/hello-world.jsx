
import AppBar from 'material-ui/AppBar';
import baseTheme from 'material-ui/styles/baseThemes/lightBaseTheme';
import getMuiTheme from 'material-ui/styles/getMuiTheme';

import React, { PropTypes } from 'react';

export default class HelloWorld extends React.Component {

    static propTypes() {
        return {username: PropTypes.string.isRequired};
    }

    getChildContext() {
        return { muiTheme: getMuiTheme(baseTheme) };
    }


    render() {
        return <div>Hello {this.props.username} <AppBar title="Title" /> </div>;


    }
}


HelloWorld.childContextTypes = {
    muiTheme: React.PropTypes.object.isRequired,
};
