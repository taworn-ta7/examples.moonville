import React from 'react';
import styles from './PageFooter.module.css';

export default function PageFooter(props) {
	return (
		<footer>
			<div className={styles.footer}>
				<div className={styles.inner}>
					designed by Oo+
				</div>
			</div>
		</footer>
	);
}
