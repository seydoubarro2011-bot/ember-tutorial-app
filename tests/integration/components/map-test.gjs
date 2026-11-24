import { module, test } from 'qunit';
import { setupRenderingTest } from 'supper-rentals/tests/helpers';
import { render, rerender } from '@ember/test-helpers';
import { tracked } from '@glimmer/tracking';
import ENV from 'supper-rentals/config/environment';
import Map from 'supper-rentals/components/map';

module('Integration | Component | map', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders a map with the correct parameters', async function (assert) {
    await render(<template>
      <Map
        @lat="37.7749"
        @lng="-122.4194"
        @zoom="9"
        @width="150"
        @height="150"
        alt="A map of San Francisco"
      />
    </template>);

    let image = this.element.querySelector('img');
    let src = image.getAttribute('src');
    let url = new URL(src);

    assert.ok(src.startsWith('https://api.tomtom.com/map/1/staticimage'));
    assert.strictEqual(
      url.searchParams.get('key'),
      ENV.TOMTOM_ACCESS_TOKEN
    );
    assert.ok(src.includes(encodeURIComponent(ENV.TOMTOM_ACCESS_TOKEN)));
    assert.strictEqual(url.searchParams.get('zoom'), '9');
    assert.strictEqual(
      url.searchParams.get('center'),
      '-122.4194,37.7749'
    );
    assert.strictEqual(url.searchParams.get('width'), '150');
    assert.strictEqual(url.searchParams.get('height'), '150');
    assert.strictEqual(image.getAttribute('alt'), 'A map of San Francisco');
  });

  test('it allows the alt attribute to be overridden', async function (assert) {
    await render(<template>
      <Map
        @lat="37.7749"
        @lng="-122.4194"
        @zoom="9"
        @width="150"
        @height="150"
        alt="Custom map description"
      />
    </template>);

    assert
      .dom('img')
      .hasAttribute('alt', 'Custom map description');
  });

  test('it does not allow src, width, or height to be overridden', async function (assert) {
    await render(<template>
      <Map
        @lat="37.7749"
        @lng="-122.4194"
        @zoom="9"
        @width="150"
        @height="150"
        src="https://example.com/incorrect.png"
        width="999"
        height="999"
      />
    </template>);

    let image = this.element.querySelector('img');

    assert.ok(
      image.getAttribute('src').startsWith(
        'https://api.tomtom.com/map/1/staticimage'
      )
    );
    assert.strictEqual(image.getAttribute('width'), '150');
    assert.strictEqual(image.getAttribute('height'), '150');
  });

  test('it updates the map when its arguments change', async function (assert) {
    class State {
      @tracked lat = '37.7749';
      @tracked lng = '-122.4194';
      @tracked zoom = '9';
    }

    this.state = new State();

    await render(<template>
      <Map
        @lat={{this.state.lat}}
        @lng={{this.state.lng}}
        @zoom={{this.state.zoom}}
        @width="150"
        @height="150"
      />
    </template>);

    let image = this.element.querySelector('img');
    let firstUrl = new URL(image.getAttribute('src'));

    assert.strictEqual(
      firstUrl.searchParams.get('center'),
      '-122.4194,37.7749'
    );
    assert.strictEqual(firstUrl.searchParams.get('zoom'), '9');

    this.state.lat = '40.7128';
    this.state.lng = '-74.0060';
    this.state.zoom = '12';

    await rerender();

    let updatedUrl = new URL(image.getAttribute('src'));

    assert.strictEqual(
      updatedUrl.searchParams.get('center'),
      '-74.0060,40.7128'
    );
    assert.strictEqual(updatedUrl.searchParams.get('zoom'), '12');
  });
});