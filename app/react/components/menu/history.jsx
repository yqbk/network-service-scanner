import React from 'react';

const History = (props) => {

    return (
        <div>
            <table className="table table-bordered">
                <thead>
                <tr>
                    <td>IP</td>
                    <td>Port</td>
                    <td>Status</td>
                    <td>Time</td>
                    <td>Method</td>
                    <td>Service</td>
                    <td>Actions</td>
                </tr>
                </thead>
                <tbody>

                {props.hosts.map(host =>
                    <tr>
                        <td>{host.IP}</td>
                        <td>{host.port}</td>
                        <td>{host.status}</td>
                        <td>{host.scann_time}</td>
                        <td>{host.scann_type}</td>
                        <td>{host.service}</td>
                        <td>
                            <a className="btn btn-info">Detect service</a>
                            <a className="btn btn-danger">delete</a>
                        </td>
                    </tr>
                )}

                </tbody>
            </table>
        </div>
    )
};

export default History