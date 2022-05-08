export const Constants = {

	/**
	 * Local base URI.
	 */
	localUri: 'http://localhost:3000',

	/**
	 * Server base URI.
	 */
	baseUri: 'http://localhost:7000/api',

	/**
	 * Static server base URI.
	 */
	baseStaticUri: 'http://localhost:7000',

	// Google Client
	googleClientId: '914472032711-15us446d98tdl80kjmtp8fbf3mvedqhr.apps.googleusercontent.com',
	googleAuthUri: 'https://accounts.google.com/o/oauth2/v2/auth',
	googleSignIn: () => {
		const scope = [
			'openid',
			'profile',
			'email',
			'https://www.googleapis.com/auth/userinfo.profile',
			'https://www.googleapis.com/auth/userinfo.email',
		];
		return Constants.googleAuthUri
			+ `?redirect_uri=${Constants.localUri}/signin/google`
			+ `&client_id=${Constants.googleClientId}`
			+ `&access_type=offline&response_type=code&prompt=consent`
			+ `&scope=${scope.join(' ')}`;
	},

	// Facebook Client
	// real app
	facebookClientId: '1693781620967181',
	// test app
	//facebookClientId: '690927985366656',
	facebookAuthUri: 'https://www.facebook.com/v13.0/dialog/oauth',
	facebookSignIn: () => {
		return Constants.facebookAuthUri
			+ `?redirect_uri=${Constants.localUri}/signin/facebook`
			//+ `?redirect_uri=https://localhost:9000/signin/facebook`
			+ `&client_id=${Constants.facebookClientId}`
			+ `&state=${`{st=m00nVi113,ds=01010}`}`
			//+ `&state=`
			+ `&response_type=code`
			//+ `&response_type=code%20token`
			+ `&scope=email`;
	},

	// LINE Client
	lineClientId: '1657018369',
	lineAuthUri: 'https://access.line.me/oauth2/v2.1/authorize',
	lineSignIn: () => {
		return Constants.lineAuthUri
			+ `?redirect_uri=${Constants.localUri}/signin/line`
			+ `&client_id=${Constants.lineClientId}`
			+ `&response_type=code&state=${`m00nVi113`}`
			+ `&scope=profile%20openid%20email`;
	},

};

export default Constants;
