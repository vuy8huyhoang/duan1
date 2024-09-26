import Body from './component/home';
export default function HomePage() {
  console.log(111);

  return (
    <div className="home-page">
      <div className="main-layout">
        <div className="content-wrapper">
          <Body />
        </div>
      </div>
    </div>
  );
}