import {api} from './api.jsx';

export const UserLogin = async (username, password) => {
    const response = await fetch(`${api}/login`, {
	method: 'POST',
	headers: {
	    "Content-type": "application/json"
	},
	body: JSON.stringify({username, password})
    });

    return response.json();
};
