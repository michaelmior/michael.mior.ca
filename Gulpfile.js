const checkPages = require("check-pages");
const cheerio = require("gulp-cheerio");
const colors = require("ansi-colors");
const favicons = require("gulp-favicons");
const fileinclude = require("gulp-file-include");
const fs = require("node:fs");
const gulp = require("gulp");
const htmllint = require("gulp-htmllint");
const htmlmin = require("gulp-htmlmin");
const mdlint = require("gulp-remark-lint-dko");
const path = require("node:path");
const rimraf = require("gulp-rimraf");
const sassLint = require("gulp-sass-lint");
const sizeOf = require("image-size");
const url = require("node:url");
const wintersmith = require("wintersmith");

const locals = JSON.parse(fs.readFileSync("config.json")).locals;

// Lint
gulp.task("lint-markdown", () => gulp
		.src("contents/**/*.md")
		.pipe(
			mdlint({
				rules: {
					"first-heading-level": false, // XXX Should really be 2 if possible
					"list-item-indent": false,
					"maximum-line-length": false,
					"no-file-name-mixed-case": false,
					"no-multiple-toplevel-headings": false,
				},
			}),
		)
		.pipe(mdlint.report()));

gulp.task("lint-sass", () => gulp
		.src("contents/styles/**/*\\.s+(a|c)ss")
		.pipe(sassLint())
		.pipe(sassLint.format())
		.pipe(sassLint.failOnError()));

gulp.task("lint", gulp.parallel("lint-markdown", "lint-sass"));

// Clean the build directory
gulp.task("clean", () => gulp
		.src("build", {
			allowEmpty: true,
			read: false,
		})
		.pipe(rimraf()));

// Helper tasks for favicons
gulp.task("favicons", () => gulp
		.src("contents/img/logo.png")
		.pipe(
			favicons({
				appName: locals.name,
				appDescription: locals.description,
				developerName: locals.owner,
				developerURL: locals.url,
				background: "#FFF",
				path: "/favicons/",
				url: locals.url,
				display: "standalone",
				orientation: "portrait",
				version: 1.0,
				logging: false,
				online: false,
				html: "index.html",
				pipeHTML: true,
				replace: true,
				icons: {
					appleStartup: false,
					coast: false,
					facebook: false,
					twitter: false,
					yandex: false,
				},
			}),
		)
		.on("error", console.error)
		.pipe(gulp.dest("build/favicons")));

function htmllintReporter(filepath, issues) {
	if (issues.length > 0) {
    for (const issue of issues) {
			console.error(
				colors.cyan("[gulp-htmllint] ") +
					colors.white(
						`${filepath} [${issue.line},${issue.column}]: `,
					) +
					colors.red(`(${issue.code}) ${issue.msg}`),
			);
		}

		process.exitCode = 1;
	}
}

gulp.task("include-html", () => gulp
		.src([
			"build/**/*.html",
			"!build/4914eddbc3a49e00fa7bcd5cc44991efa7e9a179e8cb00fb69091f77c4c59635.html",
			"!build/mywot*.html",
			"!build/pinterest-*.html",
			"!build/projects/NoSE/rubis.html",
		])
		.pipe(fileinclude({ basepath: "@root" }))
		.pipe(
			cheerio(($, file) => {
				$("img").replaceWith(function () {
					if (this.attribs.src[0] !== "/") {
						return $(this);
					}

					const img = $(/\/amp\//.test(file.path) ? "<amp-img>" : "<img>");
					img.attr("alt", this.attribs.alt);
					img.attr("src", this.attribs.src.replace(/^\/amp/, ""));
					const dimensions = sizeOf(path.join("./build", img.attr("src")));
					img.attr("width", dimensions.width);
					img.attr("height", dimensions.height);

					return img;
				});
			}),
		)
		.pipe(
			htmlmin({
				collapseBooleanAttributes: true,
				collapseWhitespace: true,
				removeComments: true,
				removeRedundantAttributes: true,
				removeScriptTypeAttributes: true,
				useShortDoctype: true,
			}),
		)
		.pipe(htmllint({}, htmllintReporter))
		.pipe(gulp.dest("build")));

// Build task
gulp.task("compile", (cb) => {
	const env = wintersmith("config.json");
	env.build(cb);
});
const build = gulp.series("clean", "compile", "favicons", "include-html");

gulp.task("checklinks", (cb) => {
	const options = {
		pageUrls: [locals.url],
		checkLinks: true,
		onlySameDomain: false,
		queryHashes: true,
		noRedirects: true,
		noLocalLinks: true,
		noEmptyFragments: true,
		checkCaching: true,
		checkCompression: true,
		summary: true,
	};
	checkPages(console, options, cb);
});

exports.build = build;
exports.default = build;
