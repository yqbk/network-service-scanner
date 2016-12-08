import React from 'react';
import LinearProgress from 'material-ui/LinearProgress';

export default class ProgressBar extends React.Component {

    constructor(props) {
        super(props);

        this.state = {
            completed: 0,
        };
    }

    componentDidMount() {
        this.setState({completed: 0});
    }

    componentDidUpdate() {

        const hostTableLenght = this.props.hostTableLenght
        const scannAmount = this.props.scannAmount

        let progressValue = hostTableLenght === 0 ? 0 : (hostTableLenght / scannAmount) * 100

        progressValue = Math.round(progressValue)

        // console.log("progress" + progressValue + " | " + hostTableLenght + "/" + scannAmount)

        progressValue === this.state.completed ? {} : this.setState({ completed: progressValue })

    }

    render() {
        return (
            <LinearProgress mode="determinate" value={this.state.completed} />
        );
    }
}