export const Rest = {
	/**
	 * Call to server.
	 */
	async fetch(uri, options) {
		// log before send
		let method;
		if (options && options.method)
			method = options.method;
		else
			method = 'GET';
		console.log(`${method} ${uri}`);

		// fetch
		try {
			const res = await fetch(uri, options);
			const data = await res.json();
			console.log(`fetch result: ${JSON.stringify(data, null, 2)}`);
			return {
				response: res,
				json: data,
				ok: res.status === 200 || res.status === 201,
			};
		}
		catch (ex) {
			console.log(`fetch error: ${ex}`);
			return null;
		}
	},

	/**
	 * Call to server.
	 */
	async fetchRaw(uri, options) {
		// log before send
		let method;
		if (options && options.method)
			method = options.method;
		else
			method = 'GET';
		console.log(`${method} ${uri}`);

		// fetch
		try {
			const res = await fetch(uri, options);
			console.log(`fetch result: ${res.status} ${res.statusText}`);
			return res;
		}
		catch (ex) {
			console.log(`fetch error: ${ex}`);
			return null;
		}
	},

	/**
	 * Get default headers.
	 */
	headers(token) {
		const t = token || this.token;
		return {
			'Content-Type': 'application/json;charset=utf-8',
			'Authorization': `Bearer ${t}`,
		};
	},

	/**
	 * Get multi-part headers.
	 */
	formDataHeaders(token) {
		const t = token || this.token;
		return {
			// NOTE: Don't include Content-Type, otherwise, it's error T_T
			//'Content-Type': 'multipart/form-data',
			'Authorization': `Bearer ${t}`,
		}
	},

	/**
	 * Token.
	 */
	token: '',
};

export default Rest;
